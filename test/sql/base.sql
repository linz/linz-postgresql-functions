\set ECHO none
--------------------------------------------------------------------------------
--
-- Copyright 2016 Crown copyright (c)
-- Land Information New Zealand and the New Zealand Government.
-- All rights reserved
--
-- This software is released under the terms of the new BSD license. See the 
-- LICENSE file for more information.
--
--------------------------------------------------------------------------------
-- Provide unit testing for LINZ misc PostgreSQL functions using pgTAP
--------------------------------------------------------------------------------
\set QUIET true
\set VERBOSITY terse
\pset format unaligned
\pset tuples_only true

SET client_min_messages TO WARNING;

--BEGIN;

\i sql/create_table_polygon_grid.sql

CREATE EXTENSION pgtap;

SELECT plan(9);

SELECT has_function( 'public', 'create_table_polygon_grid', ARRAY['name','name','name', 'double precision', 'double precision']  );

-- Test create_table_polygon_grid function {

--ERROR:  Table public.test does not exists
SELECT throws_ok( $$
  SELECT create_table_polygon_grid('public', 'test', 'g', 10, 10)
$$, $$Table public.test does not exists$$
);

CREATE TABLE public.test (g geometry);

--ERROR:  Table public.test geometry column fake does not exists
SELECT throws_ok( $$
  SELECT create_table_polygon_grid('public', 'test', 'fake', 10, 10)
$$, $$Table public.test geometry column fake does not exists$$
);

--ERROR:  Table 'public'.test column g does not contain any polygons
SELECT throws_ok( $$
  SELECT create_table_polygon_grid('public', 'test', 'g', 10, 10)
$$, $$Table 'public'.test column g does not contain any polygons$$
);

INSERT INTO public.test (g) VALUES
('POLYGON((0 0,20 0,20 20,0 20,0 0))');

--ERROR:  Table 'public'.test does not have a unique non-composite, non-null primary key
SELECT throws_ok( $$
  SELECT create_table_polygon_grid('public', 'test', 'g', 10, 10)
$$, $$Table 'public'.test does not have a unique non-composite, non-null primary key$$
);

ALTER TABLE public.test ADD id serial primary key;

SELECT is( create_table_polygon_grid('public', 'test', 'g', 10, 10)::text,
  'test_grid', 'create_table_polygon_grid returns test_grid');

-- Sum of areas is about 400 (from 20x20 original)
SELECT is( round(sum(st_area(geom))), 400::float8,
  'Sum of geometry areas is 400')
  FROM public.test_grid;

-- No single area is bigger than 100 (due to 10x10 resolution)
SELECT is_empty( $$
  SELECT id,st_area(geom)
    FROM public.test_grid
   WHERE round(ST_Area(geom)) > 100
$$, 'No grid geometry has area bigger than 100' );

-- Symdiff test
SELECT is( (
  SELECT ST_AsText(ST_SymDifference(g, (
    SELECT ST_Union(geom) FROM test_grid
  )))::text
  FROM public.test ),
  'POLYGON EMPTY'::text,
  'Symdifference between source geom and union of grid geoms is empty'
);

-- TODO: check that no geometries have an area smaller then
--       a given tolerance ?
--       ie: see https://github.com/linz/linz-postgresql-functions/issues/7

-- }

SELECT * FROM finish();

--ROLLBACK;


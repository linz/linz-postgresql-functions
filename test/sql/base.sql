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
\set ECHO none
\set QUIET true
\set VERBOSITY verbose
\pset format unaligned
\pset tuples_only true

SET client_min_messages TO WARNING;

--BEGIN;

\i sql/create_table_polygon_grid.sql

CREATE EXTENSION pgtap;

SELECT plan(1);

SELECT has_function( 'public', 'create_table_polygon_grid', ARRAY['name','name','name', 'double precision', 'double precision']  );

SELECT * FROM finish();

--ROLLBACK;


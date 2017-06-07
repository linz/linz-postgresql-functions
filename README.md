[![Build Status](https://travis-ci.org/linz/linz-postgresql-functions.svg?branch=master)](https://travis-ci.org/linz/linz-postgresql-functions)

LINZ PostgreSQL Support Functions
========================

Miscellaneous PostgreSQL functions from LINZ. 

Functions
---------

### `create_table_polygon_grid()` ###

Function that splits a table of polygons into a grid. It is designed to deal with
a small table of very large polygons which are slow to execute spatial operations
on (such as intersects). For each table polygon row the function will split it
into many rows each with a 'grid cell' of that polygon. The res_x and res_y
parameters define the resolution of cells.

	FUNCTION create_table_polygon_grid(
		p_schema_name NAME,
		p_table_name NAME,
		p_column_name NAME,
		p_res_x FLOAT8,
		p_res_y FLOAT8
	)
	RETURNS REGCLASS

**Parameters**

`p_schema_name`
: The table schema to generate the grid for

`p_table_name`
: The table name to generate the grid for

`p_res_x`
: The x resolution for the grid

`p_res_y`
: The y resolution for the grid

**Returns**

A reference to the created table of gridded polygons

**Exceptions**

throws an exception if:

- source table does not exist
- X or Y grid resolution is not greater than 0
- source table does not have a geometry column which contains Multi or single polygons
- table does not have a unique non-composite, non-null primary key
- table geometry column has multiple containing SRIDs
- the table geometry extent is not valid


**Example**

    SELECT * FROM public.create_table_polygon_grid('foo', 'bar', 0.01, 0.01)

Installation
------------

    sudo make install

Testing
-------

Testing is done using pg_regress and PgTap. To run the tests run the following command:

	make test

Building Debian packaging
--------------------------

Build the debian packages using the following command:

    dpkg-buildpackage -us -uc


Dependencies
------------

Requires PostgreSQL 9.0+/PostGIS 1.5+ and the PL/PgSQL language extension installed.

License
---------------------
This project is under 3-clause BSD License, except where otherwise specified.
See the LICENSE file for more details.


This file is used for tests which require there to be multiple headers in different relative positions to each other.

Each header should have an unique text that identifies it.

---

ATX tests.

# h1 space

#h1 nospace

#  h1 2 spaces

# h1 trailing hash #

## h2 space

##h2 nospace

## h2 trailing hash ##

### h3 space

###h3 nospace

### h3 trailing hash ###

#### h4

##### h5

###### h6

---

Relative positions.

# h1 before h2

## h2 between h1s

# h1 after h2

---

Setex tests.

setex h1
========

setex h2
--------

setex h1 single punctuation
=

setex h1 punctuation longer than header
================================

Prevent list vs Setex confusion:

- not Setex
- because list

---

Mixed tests.

setex h1 before atx
===================

## atx h2

### atx h3

# atx h1

setex h2
------------------

### atx h3 2

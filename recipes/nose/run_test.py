#!/usr/bin/env python

# Check that `setuptools` dependency is satisfied.

from nose.plugins.manager import DefaultPluginManager, EntryPointPluginManager

assert EntryPointPluginManager in DefaultPluginManager.__bases__

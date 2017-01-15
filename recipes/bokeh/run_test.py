import sys
import bokeh

#if sys.platform.startswith('linux'):
#    bokeh.test()

print('bokeh.__version__: %s' % bokeh.__version__)
assert bokeh.__version__ == '0.12.4'

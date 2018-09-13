import sys
import os
import tables
import tables._comp_bzip2
# We don't build this one on Windows.
if not sys.platform == "win32":
    import tables._comp_lzo
import tables.hdf5extension
import tables.indexesextension
import tables.linkextension
import tables.lrucacheextension
import tables.tableextension
import tables.utilsextension


if __name__ == "__main__":
    from multiprocessing import freeze_support
    freeze_support()
    tables.test()

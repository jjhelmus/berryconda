import unittest
import cv2
import tempfile
import os.path as op
import shutil
try:
    from urllib.request import urlretrieve
except ImportError:
    from urllib import urlretrieve


OPENCV_AVI_URL = 'https://github.com/opencv/opencv_extra/raw/master/testdata/highgui/video/VID00003-20100701-2204.avi'


class TestVideoRead(unittest.TestCase):
 
    @classmethod
    def setUpClass(cls):
        cls.temp_dir = tempfile.mkdtemp()
        cls.avi_path = op.join(cls.temp_dir, 'test.avi')
        urlretrieve(OPENCV_AVI_URL, cls.avi_path)

    @classmethod
    def tearDownClass(cls):
       shutil.rmtree(cls.avi_path, ignore_errors=True)

    def test_load_avi(self):
        cap = cv2.VideoCapture(self.avi_path)
        assert cap.read()[0]
 
if __name__ == '__main__':
    unittest.main()

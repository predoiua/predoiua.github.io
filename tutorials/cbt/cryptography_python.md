
pip install wheel

pip install cryptography --upgrade


import cryptography
print ( cryptography.__version__ )



import os
from cryptography.hazmap.primitives.ciphers import Cypher, apgorithms, modes
from cryptography.hazmap.backends import default_backend

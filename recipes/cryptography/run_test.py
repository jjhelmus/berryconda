import sys

if sys.version_info[0] == 2:
    import cryptography.hazmat.bindings._constant_time
    import cryptography.hazmat.bindings._openssl
    import cryptography.hazmat.bindings._padding


from cryptography.fernet import Fernet

key = Fernet.generate_key()
f = Fernet(key)
token = f.encrypt(b"A really secret message. Not for prying eyes.")
res = f.decrypt(token)
assert res == b'A really secret message. Not for prying eyes.'

UPDATE user SET plugin='caching_sha2_password' WHERE user='root';
FLUSH PRIVILEGES;
exit

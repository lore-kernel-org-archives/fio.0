Return-Path: <majianpeng@gmail.com>
MIME-Version: 1.0
From: majianpeng <majianpeng@gmail.com>
Date: Fri, 22 Mar 2013 00:13:40 -0600
Subject: [PATCH] mutex: fix the expression for checking the mutext magic.
Message-ID: <514BF694.2090004@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <JAxboe@fusionio.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 mutex.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mutex.c b/mutex.c
index af5e501..6022cdd 100644
--- a/mutex.c
+++ b/mutex.c
@@ -20,7 +20,7 @@
=20
 void fio_mutex_remove(struct fio_mutex *mutex)
 {
-    assert(mutex->magic =3D FIO_MUTEX_MAGIC);
+    assert(mutex->magic =3D=3D FIO_MUTEX_MAGIC);
     pthread_cond_destroy(&mutex->cond);
     munmap((void *) mutex, sizeof(*mutex));
 }
@@ -95,7 +95,7 @@ int fio_mutex_down_timeout(struct fio_mutex *mutex, unsig=
ned int seconds)
     struct timespec t;
     int ret =3D 0;
=20
-    assert(mutex->magic =3D FIO_MUTEX_MAGIC);
+    assert(mutex->magic =3D=3D FIO_MUTEX_MAGIC);
=20
     gettimeofday(&tv_s, NULL);
     t.tv_sec =3D tv_s.tv_sec + seconds;
@@ -127,7 +127,7 @@ int fio_mutex_down_timeout(struct fio_mutex *mutex, uns=
igned int seconds)
=20
 void fio_mutex_down(struct fio_mutex *mutex)
 {
-    assert(mutex->magic =3D FIO_MUTEX_MAGIC);
+    assert(mutex->magic =3D=3D FIO_MUTEX_MAGIC);
=20
     pthread_mutex_lock(&mutex->lock);
=20
@@ -143,7 +143,7 @@ void fio_mutex_down(struct fio_mutex *mutex)
=20
 void fio_mutex_up(struct fio_mutex *mutex)
 {
-    assert(mutex->magic =3D FIO_MUTEX_MAGIC);
+    assert(mutex->magic =3D=3D FIO_MUTEX_MAGIC);
=20
     pthread_mutex_lock(&mutex->lock);
     read_barrier();
@@ -155,25 +155,25 @@ void fio_mutex_up(struct fio_mutex *mutex)
=20
 void fio_rwlock_write(struct fio_rwlock *lock)
 {
-    assert(lock->magic =3D FIO_RWLOCK_MAGIC);
+    assert(lock->magic =3D=3D FIO_RWLOCK_MAGIC);
     pthread_rwlock_wrlock(&lock->lock);
 }
=20
 void fio_rwlock_read(struct fio_rwlock *lock)
 {
-    assert(lock->magic =3D FIO_RWLOCK_MAGIC);
+    assert(lock->magic =3D=3D FIO_RWLOCK_MAGIC);
     pthread_rwlock_rdlock(&lock->lock);
 }
=20
 void fio_rwlock_unlock(struct fio_rwlock *lock)
 {
-    assert(lock->magic =3D FIO_RWLOCK_MAGIC);
+    assert(lock->magic =3D=3D FIO_RWLOCK_MAGIC);
     pthread_rwlock_unlock(&lock->lock);
 }
=20
 void fio_rwlock_remove(struct fio_rwlock *lock)
 {
-    assert(lock->magic =3D FIO_RWLOCK_MAGIC);
+    assert(lock->magic =3D=3D FIO_RWLOCK_MAGIC);
     munmap((void *) lock, sizeof(*lock));
 }
=20
--=20
1.8.2.rc2.4.g7799588



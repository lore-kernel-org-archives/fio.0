Return-Path: <axboe@kernel.dk>
Message-ID: <54B5D956.1040907@kernel.dk>
Date: Tue, 13 Jan 2015 19:49:58 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Log Bug with fio-2.1.14 and Higher Causing fio Jobs to Time Out
References: <CAFCBNRFzOw4rVnWpHWN=FfdhDYePKwP9xo7vWdKTPR+LSpyZwQ@mail.gmail.com> <54B45DBE.4000705@kernel.dk>
In-Reply-To: <54B45DBE.4000705@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------000701060703070403040003"
To: George T Seese <george.t.seese@seagate.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------000701060703070403040003
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01/12/2015 04:50 PM, Jens Axboe wrote:
> On 01/09/2015 09:04 AM, George T Seese wrote:
>> fio team,
>>
>> I've found a bug that results in fio hanging at the end of a workload
>> involving log generation, in this case specific to latency log
>> generation. The bug appears in version 2.1.14, 2.2.4, and possibly
>> others. I have tested these scripts with 2.0.9 and they work. Slightly
>> different scripts work on 2.0.14 as well.
>>
>> Error message and script file are copy-pasted below. The job that
>> times out is not always the same job but, usually at least one does
>> time out, it's worse with more targets.
>>
>> fio: pid=37182, got signal=11
>> fio: job '/dev/sdc' hasn't exited in 60 seconds, it appears to be
>> stuck. Doing forceful exit of this job.
>>
>> [global]
>> bs=4k
>> runtime=1800
>> rw=randread
>> ;thread=1
>> direct=1
>> ioengine=libaio
>> ;offset=0
>> ;randommap=1
>> ;time_based=1
>> bwavgtime=5000
>> ;write_lat_log
>> ;stonewall=1
>> iodepth=1
>>
>> ;TargetDriveMarker
>> [/dev/sdc]
>> filename=/dev/sdc
>> write_lat_log=sdc
>>
>> [/dev/sdd]
>> filename=/dev/sdd
>> write_lat_log=sdd
>
> Thanks, I'll take a look at this.

Can you try the attached patch?

-- 
Jens Axboe


--------------000701060703070403040003
Content-Type: text/x-patch;
 name="filelock.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="filelock.patch"

diff --git a/filelock.c b/filelock.c
index 18e8875ed942..678db03be99e 100644
--- a/filelock.c
+++ b/filelock.c
@@ -20,21 +20,59 @@ struct fio_filelock {
 	struct flist_head list;
 	unsigned int references;
 };
+
+#define MAX_FILELOCKS	128
 	
-static struct flist_head *filelock_list;
-static struct fio_mutex *filelock_lock;
+struct filelock_data {
+	struct flist_head list;
+	struct fio_mutex lock;
+
+	struct fio_filelock ffs[MAX_FILELOCKS];
+	struct flist_head free_list;
+};
+
+static struct filelock_data *fld;
+
+static void put_filelock(struct fio_filelock *ff)
+{
+	flist_add(&ff->list, &fld->free_list);
+}
+
+static struct fio_filelock *get_filelock(int trylock)
+{
+	if (!flist_empty(&fld->free_list)) {
+		struct fio_filelock *ff;
+
+		ff = flist_first_entry(&fld->free_list, struct fio_filelock, list);
+		flist_del_init(&ff->list);
+		return ff;
+	}
+
+	if (trylock)
+		return NULL;
+
+	log_err("fio: should wait...\n");
+	return NULL;
+}
 
 int fio_filelock_init(void)
 {
-	filelock_list = smalloc(sizeof(*filelock_list));
-	if (!filelock_list)
-		return 1;
+	int i;
 
-	INIT_FLIST_HEAD(filelock_list);
-	filelock_lock = fio_mutex_init(FIO_MUTEX_UNLOCKED);
-	if (!filelock_lock) {
-		sfree(filelock_list);
+	fld = smalloc(sizeof(*fld));
+	if (!fld)
 		return 1;
+
+	INIT_FLIST_HEAD(&fld->list);
+	INIT_FLIST_HEAD(&fld->free_list);
+
+	__fio_mutex_init(&fld->lock, FIO_MUTEX_UNLOCKED);
+
+	for (i = 0; i < MAX_FILELOCKS; i++) {
+		struct fio_filelock *ff = &fld->ffs[i];
+
+		__fio_mutex_init(&ff->lock, FIO_MUTEX_UNLOCKED);
+		flist_add_tail(&ff->list, &fld->free_list);
 	}
 
 	return 0;
@@ -42,14 +80,23 @@ int fio_filelock_init(void)
 
 void fio_filelock_exit(void)
 {
-	if (!filelock_list)
+	if (!fld)
 		return;
 
-	assert(flist_empty(filelock_list));
-	sfree(filelock_list);
-	filelock_list = NULL;
-	fio_mutex_remove(filelock_lock);
-	filelock_lock = NULL;
+	assert(flist_empty(&fld->list));
+	fio_mutex_remove(&fld->lock);
+
+	while (!flist_empty(&fld->free_list)) {
+		struct fio_filelock *ff;
+
+		ff = flist_first_entry(&fld->free_list, struct fio_filelock, list);
+
+		flist_del_init(&ff->list);
+		fio_mutex_remove(&ff->lock);
+	}
+
+	sfree(fld);
+	fld = NULL;
 }
 
 static struct fio_filelock *fio_hash_find(uint32_t hash)
@@ -57,7 +104,7 @@ static struct fio_filelock *fio_hash_find(uint32_t hash)
 	struct flist_head *entry;
 	struct fio_filelock *ff;
 
-	flist_for_each(entry, filelock_list) {
+	flist_for_each(entry, &fld->list) {
 		ff = flist_entry(entry, struct fio_filelock, list);
 		if (ff->hash == hash)
 			return ff;
@@ -72,32 +119,36 @@ static struct fio_filelock *fio_hash_get(uint32_t hash)
 
 	ff = fio_hash_find(hash);
 	if (!ff) {
-		ff = smalloc(sizeof(*ff));
+		ff = get_filelock(0);
 		ff->hash = hash;
-		__fio_mutex_init(&ff->lock, FIO_MUTEX_UNLOCKED);
 		ff->references = 0;
-		flist_add(&ff->list, filelock_list);
+		flist_add(&ff->list, &fld->list);
 	}
 
 	return ff;
 }
 
-int fio_trylock_file(const char *fname)
+static int __fio_lock_file(const char *fname, int trylock)
 {
 	struct fio_filelock *ff;
 	uint32_t hash;
 
 	hash = jhash(fname, strlen(fname), 0);
 
-	fio_mutex_down(filelock_lock);
+	fio_mutex_down(&fld->lock);
 	ff = fio_hash_get(hash);
 	ff->references++;
-	fio_mutex_up(filelock_lock);
+	fio_mutex_up(&fld->lock);
+
+	if (!trylock) {
+		fio_mutex_down(&ff->lock);
+		return 0;
+	}
 
 	if (!fio_mutex_down_trylock(&ff->lock))
 		return 0;
 
-	fio_mutex_down(filelock_lock);
+	fio_mutex_down(&fld->lock);
 
 	/*
 	 * If we raced and the only reference to the lock is us, we can
@@ -108,7 +159,7 @@ int fio_trylock_file(const char *fname)
 		ff = NULL;
 	}
 
-	fio_mutex_up(filelock_lock);
+	fio_mutex_up(&fld->lock);
 
 	if (ff) {
 		fio_mutex_down(&ff->lock);
@@ -118,19 +169,14 @@ int fio_trylock_file(const char *fname)
 	return 1;
 }
 
-void fio_lock_file(const char *fname)
+int fio_trylock_file(const char *fname)
 {
-	struct fio_filelock *ff;
-	uint32_t hash;
-
-	hash = jhash(fname, strlen(fname), 0);
-
-	fio_mutex_down(filelock_lock);
-	ff = fio_hash_get(hash);
-	ff->references++;
-	fio_mutex_up(filelock_lock);
+	return __fio_lock_file(fname, 1);
+}
 
-	fio_mutex_down(&ff->lock);
+void fio_lock_file(const char *fname)
+{
+	__fio_lock_file(fname, 0);
 }
 
 void fio_unlock_file(const char *fname)
@@ -140,19 +186,18 @@ void fio_unlock_file(const char *fname)
 
 	hash = jhash(fname, strlen(fname), 0);
 
-	fio_mutex_down(filelock_lock);
+	fio_mutex_down(&fld->lock);
 
 	ff = fio_hash_find(hash);
 	if (ff) {
 		int refs = --ff->references;
 		fio_mutex_up(&ff->lock);
 		if (!refs) {
-			flist_del(&ff->list);
-			__fio_mutex_remove(&ff->lock);
-			sfree(ff);
+			flist_del_init(&ff->list);
+			put_filelock(ff);
 		}
 	} else
 		log_err("fio: file not found for unlocking\n");
 
-	fio_mutex_up(filelock_lock);
+	fio_mutex_up(&fld->lock);
 }

--------------000701060703070403040003--


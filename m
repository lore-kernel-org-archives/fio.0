Return-Path: <axboe@kernel.dk>
Message-ID: <54F63165.9040903@kernel.dk>
Date: Tue, 03 Mar 2015 15:10:45 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] fio: increase max smalloc pools
References: <1425383094-9242-1-git-send-email-ehrhardt@de.ibm.com> <54F62FAC.8090208@kernel.dk>
In-Reply-To: <54F62FAC.8090208@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------000002000903020707050202"
To: Christian Ehrhardt <ehrhardt@de.ibm.com>, fio@vger.kernel.org
Cc: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------000002000903020707050202
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 03/03/2015 03:03 PM, Jens Axboe wrote:
> On 03/03/2015 04:44 AM, Christian Ehrhardt wrote:
>> From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
>>
>> For our tests with about 250k files we found the smalloc pool being
>> depleated.
>> Now for us values of 3-4 would be enough, but since it is a compile
>> time switch
>> I'd like to make it safe for everybody and set 8.
>>
>> Since it is a dynamic sizing anyway that should hopefully be ok for
>> everybody.
>
> The reason it was scaled down to 1 pool is because we could run into
> situations where one of the forked processes (or threads) would cause
> the expansion of pools, and smalloc() could then return memory that
> wasn't properly shared (or valid) between all jobs. This was recently
> found and fixed, and the smalloc code should probably just be updated to
> reflect that. We can't runtime add pools safely.
>
> Right now it's 1 pool at 16MB - how about we just bump it to 64MB for
> that one pool? Or, alternatively, pre-add 4 pools initially when smalloc
> is setup?

Something like the attached, does that work for you? That's 4 pools of 
16MB added. I think that's more flexible than (the more ideal) 1 pool of 
64MB, since fio can survive if later pool additions fail. Or we can bump 
it to 8x16 just to be on the safe side...

-- 
Jens Axboe


--------------000002000903020707050202
Content-Type: text/x-patch;
 name="smalloc-pools.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="smalloc-pools.patch"

diff --git a/smalloc.c b/smalloc.c
index 66f9ec0dd5c1..378881bb4560 100644
--- a/smalloc.c
+++ b/smalloc.c
@@ -26,7 +26,7 @@
 #define SMALLOC_BPL	(SMALLOC_BPB * SMALLOC_BPI)
 
 #define INITIAL_SIZE	16*1024*1024	/* new pool size */
-#define MAX_POOLS	1		/* maximum number of pools to setup */
+#define MAX_POOLS	4		/* maximum number of pools to setup */
 
 #define SMALLOC_PRE_RED		0xdeadbeefU
 #define SMALLOC_POST_RED	0x5aa55aa5U
@@ -230,11 +230,21 @@ out_fail:
 
 void sinit(void)
 {
-	int ret;
+	int i, ret;
 
 	lock = fio_rwlock_init();
-	ret = add_pool(&mp[0], INITIAL_SIZE);
-	assert(!ret);
+
+	for (i = 0; i < MAX_POOLS; i++) {
+		ret = add_pool(&mp[i], INITIAL_SIZE);
+		if (ret)
+			break;
+	}
+
+	/*
+	 * If we added at least one pool, we should be OK for most
+	 * cases.
+	 */
+	assert(i);
 }
 
 static void cleanup_pool(struct pool *pool)
@@ -442,16 +452,17 @@ static void *smalloc_pool(struct pool *pool, size_t size)
 
 void *smalloc(size_t size)
 {
-	unsigned int i;
+	unsigned int i, end_pool;
 
 	if (size != (unsigned int) size)
 		return NULL;
 
 	global_write_lock();
 	i = last_pool;
+	end_pool = nr_pools;
 
 	do {
-		for (; i < nr_pools; i++) {
+		for (; i < end_pool; i++) {
 			void *ptr = smalloc_pool(&mp[i], size);
 
 			if (ptr) {
@@ -461,20 +472,14 @@ void *smalloc(size_t size)
 			}
 		}
 		if (last_pool) {
-			last_pool = 0;
+			end_pool = last_pool;
+			last_pool = i = 0;
 			continue;
 		}
 
-		if (nr_pools + 1 > MAX_POOLS)
-			break;
-		else {
-			i = nr_pools;
-			if (add_pool(&mp[nr_pools], size))
-				goto out;
-		}
+		break;
 	} while (1);
 
-out:
 	global_write_unlock();
 	return NULL;
 }

--------------000002000903020707050202--


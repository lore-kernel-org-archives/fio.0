Return-Path: <axboe@kernel.dk>
Subject: Re: Bug with --buffer_compress_percentage
References: <CAF+0mvmGOrVdpaobMa-ChSz2qPJqhE1s+qUbJpdHPpEo+UKcww@mail.gmail.com>
 <56533A11.4050706@kernel.dk>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <56533BE5.3010606@kernel.dk>
Date: Mon, 23 Nov 2015 09:16:37 -0700
MIME-Version: 1.0
In-Reply-To: <56533A11.4050706@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------020009060906040803070401"
To: Matthew Eaton <m.eaton82@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------020009060906040803070401
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/23/2015 09:08 AM, Jens Axboe wrote:
> On 11/20/2015 10:29 AM, Matthew Eaton wrote:
>> I noticed that sometimes using --buffer_compress_percentage would not
>> result in the desired compression.  After running some tests I found
>> that only some block sizes are affected.
>>
>> 512b, 4K, 8K, 16K, and 32K seem to work as expected.
>>
>> 64K, 128K, 256K, 512K, and 1024K exhibited the bug.  I have not tested
>> beyond 1024K.
>>
>> Here is the test script I used only changing block size for each test.
>>
>> for i in {0..100}; do
>>    fio --name=test --rw=write --bs=128k --ioengine=libaio --direct=1
>> --iodepth=32 --size=512m --refill_buffers
>> --buffer_compress_percentage=$i --filename=testfile.$i --eta=never
>> --output=/dev/null
>> done
>>
>> for i in {0..100}; do
>>    gzip -v testfile.$i &>> gzip.txt
>> done
>>
>> rm *.gz
>>
>> Below are compression results for 4K and then 128K.  For 128K, you can
>> see compression stops matching at around 50%.
>
> I think this is an artifact of how gzip compression works, it doesn't
> have an unlimited size window. It's 32k, iirc. Fio should fill so that
> it ideally would compress to the given size with an ideal compression
> algorithm.
>
> You'd probably want to use buffer_compress_chunk=x to always force fio
> to operate in sizes of that for compression, if you want to ensure that
> gzip would be able to compress to the specified ratio. I do think we
> have a loop missing though for that to do what you need, let me test
> that and report back.

I think things should work for all sizes, if you add this patch and then 
add buffer_compress_chunk=32k or similar to your job file. You can do 
that for smaller block sizes as well, fio will use the minimum of that 
chunk size or the write block size.

-- 
Jens Axboe


--------------020009060906040803070401
Content-Type: text/x-patch;
 name="big-chunk-compress.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="big-chunk-compress.patch"

diff --git a/io_u.c b/io_u.c
index 6b6b47d0a1e1..b1aa4141cdbc 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1919,6 +1919,7 @@ void fill_io_buffer(struct thread_data *td, void *buf, unsigned int min_write,
 		unsigned int perc = td->o.compress_percentage;
 		struct frand_state *rs;
 		unsigned int left = max_bs;
+		unsigned int this_write;
 
 		do {
 			rs = get_buf_state(td);
@@ -1926,20 +1927,21 @@ void fill_io_buffer(struct thread_data *td, void *buf, unsigned int min_write,
 			min_write = min(min_write, left);
 
 			if (perc) {
-				unsigned int seg = min_write;
-
-				seg = min(min_write, td->o.compress_chunk);
-				if (!seg)
-					seg = min_write;
-
-				fill_random_buf_percentage(rs, buf, perc, seg,
-					min_write, o->buffer_pattern,
-						   o->buffer_pattern_bytes);
-			} else
+				this_write = min(min_write, td->o.compress_chunk);
+				if (!this_write)
+					this_write = min_write;
+
+				fill_random_buf_percentage(rs, buf, perc,
+					this_write, this_write,
+					o->buffer_pattern,
+					o->buffer_pattern_bytes);
+			} else {
 				fill_random_buf(rs, buf, min_write);
+				this_write = min_write;
+			}
 
-			buf += min_write;
-			left -= min_write;
+			buf += this_write;
+			left -= this_write;
 			save_buf_state(td, rs);
 		} while (left);
 	} else if (o->buffer_pattern_bytes)

--------------020009060906040803070401--


Return-Path: <axboe@kernel.dk>
Message-ID: <542CA44D.1030700@kernel.dk>
Date: Wed, 01 Oct 2014 19:03:09 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: linux /dev and normal files
References: <94D0CD8314A33A4D9D801C0FE68B402958CC5D81@G4W3202.americas.hpqcorp.net> <542B52B3.5060908@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B402958CC5EBE@G4W3202.americas.hpqcorp.net> <542B5632.8030404@kernel.dk> <542B784F.5090405@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B402958CC85F9@G4W3202.americas.hpqcorp.net> <542CA321.5090608@kernel.dk>
In-Reply-To: <542CA321.5090608@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------090802030009030808080205"
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, Jon Tango <cheerios123@outlook.com>
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------090802030009030808080205
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2014-10-01 18:58, Jens Axboe wrote:
> On 2014-10-01 17:52, Elliott, Robert (Server Storage) wrote:
>>
>>
>>> -----Original Message-----
>>> From: Jens Axboe [mailto:axboe@kernel.dk]
>>> Sent: Tuesday, 30 September, 2014 10:43 PM
>>> To: Elliott, Robert (Server Storage); fio@vger.kernel.org
>>> Cc: Sitsofe Wheeler; Jon Tango
>>> Subject: Re: linux /dev and normal files
>>>
>>> On 2014-09-30 19:17, Jens Axboe wrote:
>>>> On 2014-09-30 19:12, Elliott, Robert (Server Storage) wrote:
>>>>>
>>>>>
>>>>>> -----Original Message-----
>>>>>> From: Jens Axboe [mailto:axboe@kernel.dk]
>>>>> ...
>>>>>> I'd much rather keep fio ignorant of any "special" directories,
>>>>>> even if
>>>>>> it means that sometimes you do potentially run into issues like the
>>>>>> above, where you specify a block device that does not exist.
>>>>>
>>>>> How about an option in the script:
>>>>> direct=2   file must exist and be a block device, otherwise skip it
>>>>
>>>> Might be a bit nasty to overload direct= like that. But I'd be open to
>>>> adding an option that says must_be_bdev or something, which can be a
>>>> bool as well.
>>>
>>> Totally untested patch attached (it compiles). There's a new option,
>>> filetype. If not set, if will allow any file type. Can be set to:
>>>
>>> any        default, allow any file type
>>> file       regular file
>>> bdev       block device
>>> chardev    character device
>>> pipe       pipe
>>>
>>> So for your case, you'd set
>>>
>>> filetype=bdev
>>>
>>> and you'd avoid the issue. Note that it only works for files specified
>>> with filename=. Any other way of adding a file (blktrace replay,
>>> opendir=, or fio added files when no filename= given) will ignore the
>>> filetype setting.
>>
>> Tested with 16 devices sdr to sdag, where sdaf and sdag are
>> offline.
>>
>> It prints a message about sdaf and exits, and does not
>> create a normal file in that location:
>> parse    11480 [drive_af]
>> parse    11480 Parsing section [drive_af]
>> file     11480 dup files: 0
>> parse    11480 filename=/dev/sdaf
>> parse    11480
>> parse    11480 [drive_ag]
>> parse    11480 handle_option=filename, ptr=/dev/sdaf
>> parse    11480 __handle_option=filename, type=5, ptr=/dev/sdaf
>> file     11480 add file /dev/sdaf
>> file     11480 resize file array to 1 files
>> fio: dropping file '/dev/sdaf' of wrong type
>> fio: wanted bdev, got file
>> fio: failed parsing filename=/dev/sdaf
>> fio: job drive_af dropped
>> parse    11480 free options
>> parse    11480 free options
>> io       11480 ioengine cpuio unregistered
>> io       11480 ioengine mmap unregistered
>> io       11480 ioengine sync unregistered
>> ...
>>
>> compared to a bdev that exists:
>> parse    11480 handle_option=filename, ptr=/dev/sdae
>> parse    11480 __handle_option=filename, type=5, ptr=/dev/sdae
>> file     11480 add file /dev/sdae
>> file     11480 resize file array to 1 files
>> file     11480 file 0x7f7903703a90 "/dev/sdae" added at 0
>> io       11480 load ioengine libaio
>> parse    11480 init options
>> drive_ae: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio,
>> iodepth=96
>> file     11480 dup files: 1
>> io       11480 load ioengine libaio
>>
>> That is because the do {} while (!ret) loop in
>> __parse_jobs_ini gives up on the first add_job failure.
>> add_job calls parse_options which calls handle_option
>> which fails.
>>
>> It might be better to continue to attempt to run the
>> other jobs.
>
> We should just go for the simpler create/nocreate solution, I prefer
> that. This is too involved, and it's hard to get all the cases right
> since there are a bunch of different ways that files are added. Which
> was why this patch only focused on filename=, since that is the one that
> is the most interesting. But it still isn't pretty. If we add the
> allow_file_create option, it's basically a two-liner change in a few
> places to not use O_CREAT.

That took roughly 4 minutes... Does this work? Set allow_file_create=0 
to disallow creating new files.

-- 
Jens Axboe


--------------090802030009030808080205
Content-Type: text/x-patch;
 name="allow-create.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="allow-create.patch"

diff --git a/cconv.c b/cconv.c
index 4a40ed0d647b..913313b68d47 100644
--- a/cconv.c
+++ b/cconv.c
@@ -69,6 +69,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	string_to_cpu(&o->profile, top->profile);
 	string_to_cpu(&o->cgroup, top->cgroup);
 
+	o->allow_create = le32_to_cpu(top->allow_create);
 	o->td_ddir = le32_to_cpu(top->td_ddir);
 	o->rw_seq = le32_to_cpu(top->rw_seq);
 	o->kb_base = le32_to_cpu(top->kb_base);
@@ -278,6 +279,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	string_to_net(top->profile, o->profile);
 	string_to_net(top->cgroup, o->cgroup);
 
+	top->allow_create = cpu_to_le32(o->allow_create);
 	top->td_ddir = cpu_to_le32(o->td_ddir);
 	top->rw_seq = cpu_to_le32(o->rw_seq);
 	top->kb_base = cpu_to_le32(o->kb_base);
diff --git a/filesetup.c b/filesetup.c
index 43146ba7671f..5b0c82208199 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -65,7 +65,9 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 		}
 	}
 
-	flags = O_WRONLY | O_CREAT;
+	flags = O_WRONLY;
+	if (td->o.allow_create)
+		flags |= O_CREAT;
 	if (new_layout)
 		flags |= O_TRUNC;
 
@@ -557,7 +559,7 @@ int generic_open_file(struct thread_data *td, struct fio_file *f)
 	}
 	if (td->o.sync_io)
 		flags |= O_SYNC;
-	if (td->o.create_on_open)
+	if (td->o.create_on_open && td->o.allow_create)
 		flags |= O_CREAT;
 skip_flags:
 	if (f->filetype != FIO_TYPE_FILE)
@@ -568,7 +570,7 @@ open_again:
 		if (!read_only)
 			flags |= O_RDWR;
 
-		if (f->filetype == FIO_TYPE_FILE)
+		if (f->filetype == FIO_TYPE_FILE && td->o.allow_create)
 			flags |= O_CREAT;
 
 		if (is_std)
diff --git a/options.c b/options.c
index 918de8e8e34b..b6bf47264880 100644
--- a/options.c
+++ b/options.c
@@ -1359,6 +1359,15 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_FILENAME,
 	},
 	{
+		.name	= "allow_file_create",
+		.type	= FIO_OPT_BOOL,
+		.off1	= td_var_offset(allow_create),
+		.help	= "Permit fio to create files, if they don't exist",
+		.def	= "1",
+		.category = FIO_OPT_C_FILE,
+		.group	= FIO_OPT_G_FILENAME,
+	},
+	{
 		.name	= "lockfile",
 		.lname	= "Lockfile",
 		.type	= FIO_OPT_STR,
diff --git a/thread_options.h b/thread_options.h
index a45d7b79b7ef..dd576643b31c 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -41,6 +41,7 @@ struct thread_options {
 	char *ioengine;
 	char *mmapfile;
 	enum td_ddir td_ddir;
+	unsigned int allow_create;
 	unsigned int rw_seq;
 	unsigned int kb_base;
 	unsigned int unit_base;
@@ -271,6 +272,7 @@ struct thread_options_pack {
 	uint8_t opendir[FIO_TOP_STR_MAX];
 	uint8_t ioengine[FIO_TOP_STR_MAX];
 	uint8_t mmapfile[FIO_TOP_STR_MAX];
+	uint32_t allow_create;
 	uint32_t td_ddir;
 	uint32_t rw_seq;
 	uint32_t kb_base;

--------------090802030009030808080205--


Return-Path: <kusumi.tomohiro@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALjAwxhADLVViWBc2WyDsK5LOByV39f3X2Fs5qxsTC+ExBED1A@mail.gmail.com>
References: <20170904152317.6065-1-tkusumi@tuxera.com> <CALjAwxhADLVViWBc2WyDsK5LOByV39f3X2Fs5qxsTC+ExBED1A@mail.gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Date: Mon, 4 Sep 2017 22:48:59 +0300
Message-ID: <CAHndrBkUMYUG-e6dqk9NsBBt7fJkHMH2M70-v9LrQ=K-KiFhtw@mail.gmail.com>
Subject: Re: [PATCH] don't change direct I/O xfer size during initial layout setup
Content-Type: text/plain; charset="UTF-8"
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

2017-09-04 22:36 GMT+03:00 Sitsofe Wheeler <sitsofe@gmail.com>:
> Hi,
> On 4 September 2017 at 16:23,  <kusumi.tomohiro@gmail.com> wrote:
>> From: Tomohiro Kusumi <tkusumi@tuxera.com>
>>
>> 8c43ba62('filesetup: align layout buffer') and
>> 6e344dc3('filesetup: keep OS_O_DIRECT flag when pre-allocating file')
>> need to keep the valid transfer size throughout the entire writes.
>>
>> The write(2) size may be truncated on the last write and break the
>> dio requirement. This results in td_verror() in the output.
>>
>> --
>>  # mount | grep " on / "
>>  /dev/mapper/fedora-root on / type xfs (rw,relatime,attr2,inode64,noquota)
>>  # ./fio --name=xxx --kb_base=1000 --ioengine=sync --rw=read --bs=4KiB --size=10MiB --unlink=1 --direct=1 | grep "err="
>>  xxx: (groupid=0, jobs=1): err= 0: pid=3526: Mon Sep  4 18:03:57 2017
>>  # ./fio --name=xxx --kb_base=1000 --ioengine=sync --rw=read --bs=4KiB --size=10MB --unlink=1 --direct=1 | grep "err="
>>  fio: pid=3538, err=22/file:filesetup.c:238, func=write, error=Invalid argument
>>  xxx: (groupid=0, jobs=1): err=22 (file:filesetup.c:238, func=write, error=Invalid argument): pid=3538: Mon Sep  4 18:04:04 2017
>>
>> Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
>> ---
>>  filesetup.c | 13 ++++++++++---
>>  1 file changed, 10 insertions(+), 3 deletions(-)
>>
>> diff --git a/filesetup.c b/filesetup.c
>> index 5e8ea35..42d95db 100644
>> --- a/filesetup.c
>> +++ b/filesetup.c
>> @@ -112,6 +112,7 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
>>         unsigned long long left;
>>         unsigned int bs, alloc_size = 0;
>>         char *b = NULL;
>> +       bool done = false;
>>
>>         if (read_only) {
>>                 log_err("fio: refusing extend of file due to read-only\n");
>> @@ -211,11 +212,15 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
>>                 goto err;
>>         }
>>
>> -       while (left && !td->terminate) {
>> +       while (!done && !td->terminate) {
>>                 ssize_t r;
>>
>> -               if (bs > left)
>> -                       bs = left;
>> +               /* If bs >= left this is the last write */
>> +               if (bs > left) {
>> +                       done = true;
>> +                       if (!td->o.odirect)
>> +                               bs = left;
>> +               }
>>
>>                 fill_io_buffer(td, b, bs, bs);
>>
>
> Hmm. Won't this result in a file that is bigger than requested when
> direct=1 and the maximum bs isn't an exact multiple of the extended
> filesize? Should it start trying the minimum block size at this stage
> with direct=1? If that goes on to not fit wouldn't it be better to do
> less given that the main fio job won't be able to fill the gap either?
>
> --
> Sitsofe | http://sucs.org/~sits/

The td's are also under the dio requirements.
If you really want the exact size, you can truncate(2) it.


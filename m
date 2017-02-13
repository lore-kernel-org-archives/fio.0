Return-Path: <kusumi.tomohiro@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20170213194910.GA21482@kernel.dk>
References: <20170213163239.46188-1-tkusumi@tuxera.com> <20170213163239.46188-5-tkusumi@tuxera.com>
 <20170213194910.GA21482@kernel.dk>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Date: Mon, 13 Feb 2017 22:03:56 +0200
Message-ID: <CAHndrBn6meq0J4GgvYx_h6HLjnTB-7nOLxXV4vVZhvjXy7gDTQ@mail.gmail.com>
Subject: Re: [PATCH 5/6] Acquire file ->lock while the lock itself is being copied
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

we simply can't tell the lock mode from the prototype here
   struct fio_file *f, int flags
which needs a bit of work to get the right lock ?

ok, please review the rest of the patches.


2017-02-13 21:49 GMT+02:00 Jens Axboe <axboe@kernel.dk>:
> On Mon, Feb 13 2017, kusumi.tomohiro@gmail.com wrote:
>> From: Tomohiro Kusumi <tkusumi@tuxera.com>
>>
>> to the destination file pointer.
>> The ones in dup_files() doesn't seem to require locking from
>> the way it's been called.
>>
>> Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
>> ---
>>  filesetup.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/filesetup.c b/filesetup.c
>> index 3fa8b32..7a67fe6 100644
>> --- a/filesetup.c
>> +++ b/filesetup.c
>> @@ -501,9 +501,11 @@ int file_lookup_open(struct fio_file *f, int flags)
>>       if (__f) {
>>               dprint(FD_FILE, "found file in hash %s\n", f->file_name);
>>               /*
>> -              * racy, need the __f->lock locked
>> +              * get __f->lock while it gets copied to f.
>>                */
>> +             fio_mutex_down(__f->lock);
>>               f->lock = __f->lock;
>> +             fio_mutex_up(__f->lock);
>>               from_hash = 1;
>
> What if the file lock mode is FILE_LOCK_READWRITE?
>
> --
> Jens Axboe
>


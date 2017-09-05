Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f182.google.com ([209.85.217.182]:34871 "EHLO
        mail-ua0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750858AbdIEOyv (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 5 Sep 2017 10:54:51 -0400
Received: by mail-ua0-f182.google.com with SMTP id c27so8822233uah.2
        for <fio@vger.kernel.org>; Tue, 05 Sep 2017 07:54:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <21362e1f-e266-9b49-ba62-6ca8d705e7c9@kernel.dk>
References: <20170904152317.6065-1-tkusumi@tuxera.com> <CALjAwxhADLVViWBc2WyDsK5LOByV39f3X2Fs5qxsTC+ExBED1A@mail.gmail.com>
 <CAHndrBkUMYUG-e6dqk9NsBBt7fJkHMH2M70-v9LrQ=K-KiFhtw@mail.gmail.com>
 <CALjAwxgnm7c+64kW7Y+-e36qPg8nYR_7n-=htuL5Pb6FQUPT8g@mail.gmail.com>
 <CAHndrBn0bdfC0kT5cg7TnGE3X6=SAaxCMCf9zORvx8zOxdnObw@mail.gmail.com> <21362e1f-e266-9b49-ba62-6ca8d705e7c9@kernel.dk>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Date: Tue, 5 Sep 2017 17:54:06 +0300
Message-ID: <CAHndrBk6BKQW-YdBzK7=i2VFuuBKu+nT-Uj-9X0BH8w+Nq=g=w@mail.gmail.com>
Subject: Re: [PATCH] don't change direct I/O xfer size during initial layout setup
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Tomohiro Kusumi <tkusumi@tuxera.com>

I think I've made three fixes over the original two commits.

1. non O_DIRECT dio support -> committed -> now reverted
2. segfault on fio_memfree() -> committed -> now reverted
3. this one

As far as I've seen this is it.

(I think pre read can do the same as this function, to avoid
irrelevant errors, though pre read on dio is contradictory)


2017-09-05 17:39 GMT+03:00 Jens Axboe <axboe@kernel.dk>:
> On 09/05/2017 12:14 AM, Tomohiro Kusumi wrote:
>> 2017-09-05 8:59 GMT+03:00 Sitsofe Wheeler <sitsofe@gmail.com>:
>>> On 4 September 2017 at 20:48, Tomohiro Kusumi <kusumi.tomohiro@gmail.com> wrote:
>>>> 2017-09-04 22:36 GMT+03:00 Sitsofe Wheeler <sitsofe@gmail.com>:
>>>>> Hi,
>>>>> On 4 September 2017 at 16:23,  <kusumi.tomohiro@gmail.com> wrote:
>>>>>> From: Tomohiro Kusumi <tkusumi@tuxera.com>
>>>>>>
>>>>>> 8c43ba62('filesetup: align layout buffer') and
>>>>>> 6e344dc3('filesetup: keep OS_O_DIRECT flag when pre-allocating file')
>>>>>> need to keep the valid transfer size throughout the entire writes.
>>>>>>
>>>>>> The write(2) size may be truncated on the last write and break the
>>>>>> dio requirement. This results in td_verror() in the output.
>>>>>>
>>> [...]
>>>>>> ---
>>>>>>  filesetup.c | 13 ++++++++++---
>>>>>>  1 file changed, 10 insertions(+), 3 deletions(-)
>>>>>>
>>>>>> diff --git a/filesetup.c b/filesetup.c
>>>>>> index 5e8ea35..42d95db 100644
>>>>>> --- a/filesetup.c
>>>>>> +++ b/filesetup.c
>>>>>> @@ -112,6 +112,7 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
>>>>>>         unsigned long long left;
>>>>>>         unsigned int bs, alloc_size = 0;
>>>>>>         char *b = NULL;
>>>>>> +       bool done = false;
>>>>>>
>>>>>>         if (read_only) {
>>>>>>                 log_err("fio: refusing extend of file due to read-only\n");
>>>>>> @@ -211,11 +212,15 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
>>>>>>                 goto err;
>>>>>>         }
>>>>>>
>>>>>> -       while (left && !td->terminate) {
>>>>>> +       while (!done && !td->terminate) {
>>>>>>                 ssize_t r;
>>>>>>
>>>>>> -               if (bs > left)
>>>>>> -                       bs = left;
>>>>>> +               /* If bs >= left this is the last write */
>>>>>> +               if (bs > left) {
>>>>>> +                       done = true;
>>>>>> +                       if (!td->o.odirect)
>>>>>> +                               bs = left;
>>>>>> +               }
>>>>>>
>>>>>>                 fill_io_buffer(td, b, bs, bs);
>>>>>>
>>>>>
>>>>> Hmm. Won't this result in a file that is bigger than requested when
>>>>> direct=1 and the maximum bs isn't an exact multiple of the extended
>>>>> filesize? Should it start trying the minimum block size at this stage
>>>>> with direct=1? If that goes on to not fit wouldn't it be better to do
>>>>> less given that the main fio job won't be able to fill the gap either?
>>>>
>>>> The td's are also under the dio requirements.
>>>> If you really want the exact size, you can truncate(2) it.
>>>
>>> Technically didn't fio already truncate the file to the correct size
>>> prior to starting direct layout over on
>>> https://github.com/axboe/fio/blob/d33db728d79386d544be93c24f4e3383f2a47143/filesetup.c#L191
>>> ?
>>
>> You were talking about the size *after* the write....
>
> How many fixups for a simple "use O_DIRECT for layout if the job file
> has direct=1 set" have we done now? I'm going to revert the whole thing,
> and if someone can convince me that a simple clean patch that gets all
> of it right exists, then please do send it. But until that happens,
> we're going back to the old behavior of just using buffered IO to lay it
> out.
>
> --
> Jens Axboe
>

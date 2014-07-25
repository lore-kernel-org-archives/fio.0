Return-Path: <jiri.horky@gmail.com>
Message-ID: <53D20B84.4020403@gmail.com>
Date: Fri, 25 Jul 2014 09:47:16 +0200
From: Jiri Horky <jiri.horky@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Allow to reset offset_increment counter
References: <537F439E.9040904@gmail.com> <537F7E8E.4050200@kernel.dk> <537F8454.3020203@gmail.com> <538CC242.60109@gmail.com>
In-Reply-To: <538CC242.60109@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Hi Jens,

I wonder if you missed this email or you just didn't like the patch?

Regards
Jiri Horky

On 06/02/2014 08:28 PM, Jiri Horky wrote:
> Hi,
>
> so here is another try. I thought about it a little and I think that it
> only makes sense to define offset_increment together with numjobs=X
> setting, i.e. when using subjobs. The patch reflects this. Each subjob
> starts at next offset_increment for each file it operates on.
>
> Cheers
> Jirka H.
>
>
> On 05/23/2014 07:24 PM, Jiri Horky wrote:
>> Hi Jens,
>> On 05/23/2014 06:59 PM, Jens Axboe wrote:
>>> On 2014-05-23 06:48, Jiri Horky wrote:
>>>> Hi all,
>>>>
>>>> because I got bitten by this multiple times I decided to give this patch
>>>> a try :)
>>>>
>>>> Current implementation of offset calculation when offset_increment is in
>>>> effect uses global thread_number as follows:
>>>>      f->file_offset = td->o.start_offset + (td->thread_number - 1) *
>>>> td->o.offset_increment;
>>>>
>>>> The thread number gets incremented for every job (subjob) so even you
>>>> have multiple jobs with different filenames, the offset calculation is
>>>> shared. I find this very unintuitive, especially in cases the offsets
>>>> gets past the device/file. For example, if one wants to run sequential
>>>> read test in 16 threads of multiple devices (/dev/sd{b,c,d}) in one
>>>> group, which are of  1TB size, and to eliminate caching effect he wants
>>>> each read to start at different offset, the config could look like
>>>> following:
>>> Maybe it would be better to have this offset calculation be on a
>>> per-thread-per-file basis? You are right in that it only makes sense
>>> within the same file or device, so maybe it'd be better to make it
>>> work more like you expect.
>> I agree it should definitely be file-based, I just wasn't sure how you
>> would express that in the config file. Or you mean that that the offset
>> calculation would not be shared between different jobs (not subjobs)
>> even if they share the same file?
>> The fact is that one can always calculate the start offset in the new
>> job definition if he needs the offset calculation to be shared. And if
>> there are multiple files within a job, the offset_increment should be
>> independent.
>>
>> I will try to look at this.
>>
>> Jiri
>>



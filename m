Return-Path: <gurvindersinghdahiya@gmail.com>
Return-Path: <gurvindersinghdahiya@gmail.com>
Subject: Re: client/server test to write to single file from all clients
References: <a001b187-7ced-1295-2f6d-80039621aa88@gmail.com>
 <5727FBC2.1020000@kernel.dk>
From: Gurvinder Singh <gurvindersinghdahiya@gmail.com>
Message-ID: <811a7234-cb9a-6adb-5caa-453262db1986@gmail.com>
Date: Tue, 3 May 2016 07:34:27 +0200
MIME-Version: 1.0
In-Reply-To: <5727FBC2.1020000@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Reposting it as gmail android client inserted html and it got rejected
from mailing list.
-----------------------------
Thanks Jens for the reply. As FIO supports writing to same file in
client/server mode then what should be filename/filename_pattern should be.
As currently specifying filename it appends hostname/IP to file name and
thus each client ends up writing to its own file.

-------------------------------
- Gurvinder

On 05/03/2016 03:15 AM, Jens Axboe wrote:
> On 05/01/2016 01:11 PM, Gurvinder Singh wrote:
>> Hi,
>>
>> First of all thanks for such a nice tool to do IO testing. I am
>> wondering if it is possible to test accessing a single file from
>> multiple clients to test distributed file system behavior.
>>
>> The reason for this test is to see if it has different behavior than
>> having numjobs > 1 accessing same file running on same host.
> 
> Sure, you can do that. Fio doesn't really care about whether the file is
> shared or not. Obviously some things like verification might not work
> properly, but just reading and writing to a shared file, fio doesn't
> care if it's local or not.
> 
> 



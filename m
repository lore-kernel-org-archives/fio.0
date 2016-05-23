Return-Path: <gurvindersinghdahiya@gmail.com>
Return-Path: <gurvindersinghdahiya@gmail.com>
Subject: Re: client/server test to write to single file from all clients
References: <a001b187-7ced-1295-2f6d-80039621aa88@gmail.com>
 <5727FBC2.1020000@kernel.dk> <811a7234-cb9a-6adb-5caa-453262db1986@gmail.com>
 <CALjAwxgLWN=teei=LJj7rJHJ8MDSYJJ7i_XHKYkdPq2S9b1efA@mail.gmail.com>
 <547897333.64878071.1463955939138.JavaMail.zimbra@redhat.com>
From: Gurvinder Singh <gurvindersinghdahiya@gmail.com>
Message-ID: <f37c3ecc-099f-736d-a89b-a77b7627b165@gmail.com>
Date: Mon, 23 May 2016 18:53:04 +0200
MIME-Version: 1.0
In-Reply-To: <547897333.64878071.1463955939138.JavaMail.zimbra@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Ben England <bengland@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org, Sitsofe Wheeler <sitsofe@gmail.com>
List-ID: <fio@vger.kernel.org>

On 05/23/2016 12:25 AM, Ben England wrote:
> Gurvinder, 
> 
> you are correct, there is a problem at present getting fio threads on multiple clients to share files using the --client option, because it does insert the IP addr of the client in the pathname.  I think the current behavior is a reasonable default behavior - we want "embarrassingly parallel" behavior normally.  For example, fio threads within a single client run on separate files by default.  But it would be useful to be able to override this and have clients share files - this option would be useful for testing distributed filesystems for example.   Perhaps a "--shared-across-clients" option, valid only when --client specified, would be useful in this case?  This would just suppress the insertion of IP address into the filename.  It should be feasible to do this, if people agree that this is what they want. 
> 
Thanks Ben for confirming the issue. Yeah the original idea was to test
the distributed file system with multiple clients and writing to same
file. I do understand the verification part is hard to implement in this
case. But adding an option which Jens just did is a good start.

Thanks Jens for fixing it.

- Gurvinder
> Jens' comment about being unable to verify or predict file contents does apply, if writes are done this way.  So you wouldn't really have a way to know if your writes or reads succeeded.   To make this possible, I suspect fio would need to serialize writes from different clients to the same byte range within a file, I don't know if this can be easily done.
> 
> -ben
> 
> ----- Original Message -----
>> From: "Sitsofe Wheeler" <sitsofe@gmail.com>
>> To: "Gurvinder Singh" <gurvindersinghdahiya@gmail.com>
>> Cc: "Jens Axboe" <axboe@kernel.dk>, fio@vger.kernel.org
>> Sent: Tuesday, May 3, 2016 2:18:04 PM
>> Subject: Re: client/server test to write to single file from all clients
>>
>> On 3 May 2016 at 06:34, Gurvinder Singh <gurvindersinghdahiya@gmail.com>
>> wrote:
>>> Reposting it as gmail android client inserted html and it got rejected
>>> from mailing list.
>>> -----------------------------
>>> Thanks Jens for the reply. As FIO supports writing to same file in
>>> client/server mode then what should be filename/filename_pattern should be.
>>> As currently specifying filename it appends hostname/IP to file name and
>>> thus each client ends up writing to its own file.
>>
>> Can you post your jobfile here?
>>
>> --
>> Sitsofe | http://sucs.org/~sits/
>> --
>> To unsubscribe from this list: send the line "unsubscribe fio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>



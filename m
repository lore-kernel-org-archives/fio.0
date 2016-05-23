Return-Path: <axboe@kernel.dk>
Subject: Re: client/server test to write to single file from all clients
References: <a001b187-7ced-1295-2f6d-80039621aa88@gmail.com>
 <5727FBC2.1020000@kernel.dk> <811a7234-cb9a-6adb-5caa-453262db1986@gmail.com>
 <CALjAwxgLWN=teei=LJj7rJHJ8MDSYJJ7i_XHKYkdPq2S9b1efA@mail.gmail.com>
 <547897333.64878071.1463955939138.JavaMail.zimbra@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <574315D0.6000401@kernel.dk>
Date: Mon, 23 May 2016 08:38:08 -0600
MIME-Version: 1.0
In-Reply-To: <547897333.64878071.1463955939138.JavaMail.zimbra@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Ben England <bengland@redhat.com>, Gurvinder Singh <gurvindersinghdahiya@gmail.com>
Cc: fio@vger.kernel.org, Sitsofe Wheeler <sitsofe@gmail.com>
List-ID: <fio@vger.kernel.org>

On 05/22/2016 04:25 PM, Ben England wrote:
> Gurvinder,
>
> you are correct, there is a problem at present getting fio threads on
> multiple clients to share files using the --client option, because it
> does insert the IP addr of the client in the pathname.  I think the
> current behavior is a reasonable default behavior - we want
> "embarrassingly parallel" behavior normally.  For example, fio threads
> within a single client run on separate files by default.  But it would
> be useful to be able to override this and have clients share files -
> this option would be useful for testing distributed filesystems for
> example.   Perhaps a "--shared-across-clients" option, valid only when
> --client specified, would be useful in this case?  This would just
> suppress the insertion of IP address into the filename.  It should be
> feasible to do this, if people agree that this is what they want.

Just add an option that default to on to retain the existing behavior,
but allows you to turn off the IP prefixing. I'm open to suggestions. It
only happens with a directory prefix, which is indeed a bit odd.o

http://git.kernel.dk/cgit/fio/commit/?id=922a5be82ca50f7c89a1f9c4b84757ba8636e2d1

-- 
Jens Axboe



Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:43293 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803Ab1FANRb (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 1 Jun 2011 09:17:31 -0400
Message-ID: <4DE63BE8.60105@fusionio.com>
Date: Wed, 1 Jun 2011 15:17:28 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: Unaligned AIO/DIO
References: <4DE531D0.40600@arvin.dk> <4DE61875.4070501@fusionio.com> <4DE635E0.8060808@arvin.dk>
In-Reply-To: <4DE635E0.8060808@arvin.dk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Troels Arvin <troels@arvin.dk>
Cc: fio@vger.kernel.org

On 2011-06-01 14:51, Troels Arvin wrote:
> Hello,
> 
> Jens Axboe wrote:
>> Do you have the RHEL6.1 kernel sources handy?
> 
> I just grabbed the particular kernel package'es source-package, installed it into ~/rpmbuild and ran "rpmbuild -bp" on its spec-file which should result in all RHs patches to be applied.
> 
> From the resulting code in ~/rpmbuild/BUILD/..., I grabbed file.c and placed it here:
> http://troels.arvin.dk/misc/fio/unaligned/
> 
> Lines close to the error message (probably wrapped by my mailer):
> 
>     /* Unaligned direct AIO must be serialized; see comment above */
>     if (unaligned_aio) {
>         static unsigned long unaligned_warn_time;
> 
>         /* Warn about this once per day */
>         if (printk_timed_ratelimit(&unaligned_warn_time, 60*60*24*HZ))
>             ext4_msg(inode->i_sb, KERN_WARNING,
>                  "Unaligned AIO/DIO on inode %ld by %s; "
>                  "performance will be poor.",
>                  inode->i_ino, current->comm);
> 
>         mutex_lock(&EXT4_I(inode)->i_aio_mutex);
>         ext4_aiodio_wait(inode);
>      }

Ah, so this is indeed the < 4KB O_DIRECT writes. The iometer like test
case you are using is meant to be used on a raw block device, not on a
file system. For a file system, doing less than the block size of IO
will incur RMW cycles and thus be very slow compared to full block size
(or more) O_DIRECT writes.

If you want to run it on the fs, either change the block size mappings
to avoid anything less than 4K. Or change the fs to be formatted with
512b blocks.

Or just run the test on the raw device :-)

-- 
Jens Axboe


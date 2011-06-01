Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp.fullrate.dk ([90.185.1.42]:50826 "EHLO smtp.fullrate.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774Ab1FAMvs (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 1 Jun 2011 08:51:48 -0400
Received: from arvinserver1.home.troels.arvin.dk (1608ds2-ksa.0.fullrate.dk [90.184.71.151])
	by smtp.fullrate.dk (Postfix) with ESMTP id 698919D0FE
	for <fio@vger.kernel.org>; Wed,  1 Jun 2011 14:51:47 +0200 (CEST)
Received: from localhost (arvinserver1.home.troels.arvin.dk [127.0.0.1])
	by arvinserver1.home.troels.arvin.dk (Postfix) with ESMTP id 3CB68108122
	for <fio@vger.kernel.org>; Wed,  1 Jun 2011 14:51:46 +0200 (CEST)
Received: from arvinserver1.home.troels.arvin.dk ([127.0.0.1])
	by localhost (arvinserver1.home.troels.arvin.dk [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 6VuwhOFUgNn1 for <fio@vger.kernel.org>;
	Wed,  1 Jun 2011 14:51:44 +0200 (CEST)
Received: from kurt-IV.home.troels.arvin.dk (kurt-IV.home.troels.arvin.dk [192.168.1.9])
	by arvinserver1.home.troels.arvin.dk (Postfix) with ESMTP id A9BFE108103
	for <fio@vger.kernel.org>; Wed,  1 Jun 2011 14:51:44 +0200 (CEST)
Message-ID: <4DE635E0.8060808@arvin.dk>
Date: Wed, 01 Jun 2011 14:51:44 +0200
From: Troels Arvin <troels@arvin.dk>
MIME-Version: 1.0
Subject: Re: Unaligned AIO/DIO
References: <4DE531D0.40600@arvin.dk> <4DE61875.4070501@fusionio.com>
In-Reply-To: <4DE61875.4070501@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,

Jens Axboe wrote:
> Do you have the RHEL6.1 kernel sources handy?

I just grabbed the particular kernel package'es source-package, 
installed it into ~/rpmbuild and ran "rpmbuild -bp" on its spec-file 
which should result in all RHs patches to be applied.

 From the resulting code in ~/rpmbuild/BUILD/..., I grabbed file.c and 
placed it here:
http://troels.arvin.dk/misc/fio/unaligned/

Lines close to the error message (probably wrapped by my mailer):

	/* Unaligned direct AIO must be serialized; see comment above */
	if (unaligned_aio) {
		static unsigned long unaligned_warn_time;

		/* Warn about this once per day */
		if (printk_timed_ratelimit(&unaligned_warn_time, 60*60*24*HZ))
			ext4_msg(inode->i_sb, KERN_WARNING,
				 "Unaligned AIO/DIO on inode %ld by %s; "
				 "performance will be poor.",
				 inode->i_ino, current->comm);

		mutex_lock(&EXT4_I(inode)->i_aio_mutex);
		ext4_aiodio_wait(inode);
  	}

-- 
Regards,
Troels Arvin <troels@arvin.dk>
http://troels.arvin.dk/

Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:47139 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab2DEOmN (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 5 Apr 2012 10:42:13 -0400
Message-ID: <4F7DAF3D.2050000@kernel.dk>
Date: Thu, 05 Apr 2012 08:42:05 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio problems
References: <4F7BEC92.8000100@suse.de> <4F7CA5F1.2050309@kernel.dk> <4F7D5CF8.40703@suse.de>
In-Reply-To: <4F7D5CF8.40703@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Danny Kukawka <dkukawka@suse.de>
Cc: fio@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 2012-04-05 02:51, Danny Kukawka wrote:
>>> 3) fio always reports minb == maxb and aggrb < minb as you can see
>>> above. From my understanding this would be false info.
>>
>> Yeah, it's a cosmetic thing. I've never really taken the time to look at
>> that...
> 
> It's not cosmetic if you need correct values for your tests ...

Most people don't use the group reporting, but yes of course it should
be correct. I have checked in a patch to correct it. The min/max group
report bandwidth were off by 1.024, the aggregate was correct (and
matched the "real" data output).

>>> 4) If we define rw=randrw, rwmixread=80, rwmixwrite=20 and the verify
>>> options, what does the READ process if there isn't enough data written
>>> out yet? Which data does READ read and verify?
>>
>> If you have a split workload like that and are also doing verifies, the
>> read can be either a read verify or just an offset read. In the latter
>> case, it doesn't verify anything. It'll just read a block (or multiple
>> blocks) at some offset instead of writing it.
> 
> That would may explain the fio over-report in 1).
> 
> We create a new RBD on the cluster, mount it on the client and let fio
> start it's test on the RBD. The RBD is completely empty at this moment.
> Not sure what happens if fio reads some random offset that may isn't
> filled with data at this moment. Or is fio only reading from a prior
> written block/offset?

OK, if we back up a bit. If you have a workload that is rwmixread=50,
hence doing equal amount of random reads and writes. Then the job will
read 50% of the disk, and write 50% of the disk. None of the read and
write offsets will be the same. So if the drive is initially empty, you
are reading non-initialized data.

Same thing is true for your workload. So some of the reads you see will
be the verifies, but some of them will also be for parts of the disk
that you will then never write.

- -- 
Jens Axboe

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBCAAGBQJPfa85AAoJEPfTWPspceCmPX0P/jyhie1ZJnLOgZ8iAuBK0AIY
fxY/X9z8h1rx7VqCSbYkEs9MQsMZzuw8piHK76TagE+VBzLNjP6eXNMGwAZU9YMS
4e9gSRWmBLIRTLhEthW7d6aUKV5N6bFDdywhMqFjlk8v6BMuTzsiakMV11HILdA6
WLlmazhyxIsaFc024wXZyQbwovD2R6iUEZb3uydN/t05gOj1R1EJ6nSReUsvJ6HN
F6iy3nLLxrqMsegaZPPBQmHyTdrQB1u2dAlFjGEiQ+ROG0SlnxI34kpqJmXd+fIl
7G5parEu9zkOQOcU2SUVWJMRYh2BM5+F2lT9D31bEdhtBowNIJDh7tr0YRdZst/y
s3BKl/6sskZTLlI4IJDEauaYZYJEdaYzZPTzTqwGLZejBai8YuDikCooK4Q/a0yH
qHJFlDL86k+XZ3nrW65op0juILbH8dWs8VIJjG49y8ChXUIu9tTu4j2Zl2mm/WOD
apweCVPUH6cGBfgkLin62T129PdSc8iKDbAJNn39UZGY5OxeAvEgSXQf79nMmTYu
w0Ntw8WvZe1g7gT6d/hk32QP76tguAwyNTnoPYuKU+bablHaHMMFNGtneXGfT5SI
gYtUobCx1oUW1WHByGerAM1E6ADaEByaXbYzYWM6VGiNRrLNPoZAYx4mP1negCG1
0oFxyRGT3ZwOKskaRFrC
=lhlr
-----END PGP SIGNATURE-----

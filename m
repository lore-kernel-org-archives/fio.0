Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:48172 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab2DEPlm (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 5 Apr 2012 11:41:42 -0400
Message-ID: <4F7DBD2D.4020602@kernel.dk>
Date: Thu, 05 Apr 2012 09:41:33 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio problems
References: <4F7BEC92.8000100@suse.de> <4F7CA5F1.2050309@kernel.dk> <4F7D5CF8.40703@suse.de> <4F7DAF3D.2050000@kernel.dk> <4F7DBA89.7080609@suse.de>
In-Reply-To: <4F7DBA89.7080609@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Danny Kukawka <dkukawka@suse.de>
Cc: fio@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 2012-04-05 09:30, Danny Kukawka wrote:
>>> We create a new RBD on the cluster, mount it on the client and let fio
>>> start it's test on the RBD. The RBD is completely empty at this moment.
>>> Not sure what happens if fio reads some random offset that may isn't
>>> filled with data at this moment. Or is fio only reading from a prior
>>> written block/offset?
>>
>> OK, if we back up a bit. If you have a workload that is rwmixread=50,
>> hence doing equal amount of random reads and writes. Then the job will
>> read 50% of the disk, and write 50% of the disk. None of the read and
>> write offsets will be the same. So if the drive is initially empty, you
>> are reading non-initialized data.
>>
>> Same thing is true for your workload. So some of the reads you see will
>> be the verifies, but some of them will also be for parts of the disk
>> that you will then never write.
> 
> We solved it now by running an initial fio write over the full RBD
> before running any verify tests:
> 
>  fio --name=fill-rbd --filename=/dev/rbd1 --direct=1 --rw=write \
>      --bs=4M --size=25g --ioengine=libaio --iodepth=128
> 
> Now we don't see problems with over-reporting fio anymore.

Excellent, so it was down to reading un-written data. Thanks for
confirming.

- -- 
Jens Axboe

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBCAAGBQJPfb0qAAoJEPfTWPspceCmzawP/RLbtj62iOVuFJm5rK42Mmq0
Texy8U9RJz4D4h5oc9xAQkvlavBGPWnf0WgsnbkSr7tc/STtqVg5GW6Y8ybvfAkw
2OlZt5T/vb23uz8L9OKp+HCjV6p6Mq7lbksAcddeZdPp9GyzE+v/Cby7LMjIRgjd
OPtq759KCb/fr2gWYpxJyyyZlXost1RrRnE+OsnKhThqIYFg42G4IpdmaZGbLeTi
3EeXTNE5RDSplnuu1BsE9jffaTZuTbjm4HbCiMyixXEtp/dZBrS4tlmClC7bpjdt
SQMp68wBvji26f7K91JcjENvagGBEmi6SRJxCUgNmmZhKr3Kaf39JzbN9zEPIHOp
zOlWomS0D9Qpj0Sh24x81nlQXbWDP0aLmrggH6w5rlqLGl3pq1kz3Wgn+RkwcObw
ri8JYy8aVqT5YCVNIriIW5rQCg7kmJp170ZH6YaPd7+SeiifX8ICWFplbKHjF5Vs
vnnysT9gYEH0PLqpcoVHaYV2SFKEWVtHo7yvpqsyVevdP6uwFFXg83pAERDPsxcc
ro2VOhdJON+AhcgdgUmyfWxfcbDQnpyuw5v3/lMc2LB1oqgfKjXgW6CxqOh+tPmX
IUrpomRX+6B4WxPBxCm1Ivpr7Vja9DdFspKBZhRH4i7LErwWKTVMBKv6CaS+zxZn
bK8sy3IbjEeGP+Mv+aHs
=RYtK
-----END PGP SIGNATURE-----

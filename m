Return-Path: <ecomar@uk.ibm.com>
In-Reply-To: <OFD80C407E.DC45623D-ON80257B6F.007F5485-80257B6F.007FC70E@uk.ibm.com>
References: <OFB8065112.FF17BF54-ON80257B6F.00062897-80257B6F.000821C0@uk.ibm.com> <20130518065341.GJ19781@kernel.dk> <20130518070110.GK19781@kernel.dk> <OFCAFB895A.56FC581E-ON80257B6F.003AA486-80257B6F.003BB600@uk.ibm.com> <OFEF259463.FACECBD6-ON80257B6F.003C54FB-80257B6F.003CA237@LocalDomain> <OF1E75BC9A.821D96E0-ON80257B6F.003CB4BE-80257B6F.003E2AAA@uk.ibm.com> <20130518122211.GM19781@kernel.dk> <OF4E37C571.40B0273E-ON80257B6F.005B05C5-80257B6F.005DC361@uk.ibm.com> <OFD80C407E.DC45623D-ON80257B6F.007F5485-80257B6F.007FC70E@uk.ibm.com>
MIME-Version: 1.0
Subject: Re: output - aggregate read bandwitdh
From: Edoardo Comar <ECOMAR@uk.ibm.com>
Message-ID: <OFE288D6C7.BEB7BBEB-ON80257B73.002E3467-80257B73.002E896D@uk.ibm.com>
Date: Wed, 22 May 2013 09:28:08 +0100
Content-Type: text/plain; charset="US-ASCII"
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

> 
> I just tried the code from git on my personal macbook.
> I replaced libaio with posixaio in the config file and 
> the ultra-high aggrb read is there too (files being created).
> 
> is caused by the contribution to the aggregate stats 
> of the second of the two query threads [queryB]
> 
> 
> Run status group 0 (all jobs):
>    READ: io=16350MB, aggrb=277927KB/s, minb=10KB/s, maxb=278418KB/s, 
> mint=60001msec, maxt=60240msec
>   WRITE: io=10164KB, aggrb=168KB/s, minb=8KB/s, maxb=160KB/s, 
> mint=60088msec, maxt=60240msec

Hi, are there any insight on the READ aggrb issue?
I'm fairly confident it's a bug now that I see it happening even on 
different platforms (mac and linux) 

thanks
Edo
Unless stated otherwise above:
IBM United Kingdom Limited - Registered in England and Wales with number 
741598. 
Registered office: PO Box 41, North Harbour, Portsmouth, Hampshire PO6 3AU



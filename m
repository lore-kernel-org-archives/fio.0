Return-Path: <ecomar@uk.ibm.com>
In-Reply-To: <20130522085736.GE9714@kernel.dk>
References: <OFB8065112.FF17BF54-ON80257B6F.00062897-80257B6F.000821C0@uk.ibm.com> <20130518065341.GJ19781@kernel.dk> <20130518070110.GK19781@kernel.dk> <OFCAFB895A.56FC581E-ON80257B6F.003AA486-80257B6F.003BB600@uk.ibm.com> <OFEF259463.FACECBD6-ON80257B6F.003C54FB-80257B6F.003CA237@LocalDomain> <OF1E75BC9A.821D96E0-ON80257B6F.003CB4BE-80257B6F.003E2AAA@uk.ibm.com> <20130518122211.GM19781@kernel.dk> <OF4E37C571.40B0273E-ON80257B6F.005B05C5-80257B6F.005DC361@uk.ibm.com> <OFD80C407E.DC45623D-ON80257B6F.007F5485-80257B6F.007FC70E@uk.ibm.com> <OFE288D6C7.BEB7BBEB-ON80257B73.002E3467-80257B73.002E896D@uk.ibm.com> <20130522085736.GE9714@kernel.dk>
MIME-Version: 1.0
Subject: Re: output - aggregate read bandwitdh
From: Edoardo Comar <ECOMAR@uk.ibm.com>
Message-ID: <OF4C0E9045.FB0B29B3-ON80257B73.0036DB50-80257B73.00373934@uk.ibm.com>
Date: Wed, 22 May 2013 11:03:01 +0100
Content-Type: text/plain; charset="US-ASCII"
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

> 
> It would help a lot if you could do a git bisect and reliably find out
> which commit caused the problem. The procedure is something like this,
> assuming you are in the fio git repository:
> 
> You continue this process until it tells you which one is the offending
> commit. Then you mail that here :-)
> 
> -- 
> Jens Axboe
> 

Thanks for the detailed explanataion
please find the log below,
Edo

[ecomar@edow500 fio]$ git bisect bad
Bisecting: 0 revisions left to test after this (roughly 0 steps)
[78c1111eacdb594e0488d5adc508091fc2a3af88] Fix variable type warning

[ecomar@edow500 fio]$ git bisect log
git bisect start
# good: [ffa93ca9d8d37ef795904773a22bf4ea77f58373] Fio 2.0.13
git bisect good ffa93ca9d8d37ef795904773a22bf4ea77f58373
# bad: [4728b3c82f07612d64b79a67adc31dd9ca3c79fc] fusion atomic: retrieve 
all capabilities and support larger writes
git bisect bad 4728b3c82f07612d64b79a67adc31dd9ca3c79fc
# good: [73cfb8a7da365c37253662477edb54ecc19575df] Merge branch 'gfio' of 
ssh://brick.kernel.dk/data/git/fio into gfio
git bisect good 73cfb8a7da365c37253662477edb54ecc19575df
# bad: [44583e022320424d145dbf01d51480e4c9a71126] Fixup commit error in 
56c796
git bisect bad 44583e022320424d145dbf01d51480e4c9a71126
# bad: [fd112d34a2cfdc2d9efcd394e38b6d87b357c23d] Fix percentile_list 
option
git bisect bad fd112d34a2cfdc2d9efcd394e38b6d87b357c23d
# bad: [cfd94f79c362da249d22a59b6ede367ce3d2ba1d] configure: fixup Windows
git bisect bad cfd94f79c362da249d22a59b6ede367ce3d2ba1d
# bad: [17f0fd39d8b1f8edb420721c38302bd46254db03] axmap: clear 
map->first_free when we reset it
git bisect bad 17f0fd39d8b1f8edb420721c38302bd46254db03
# bad: [c81f9347e5849a6b97a02f215f1c474e27c79f1a] Add CONFIG_64BIT_LLP64, 
CONFIG_POSIX_FALLOCATE and CONFIG_LINUX_FALLOCATE to Makefile.
git bisect bad c81f9347e5849a6b97a02f215f1c474e27c79f1a
# bad: [d537c08b0eacdeb05835ee8c5f269b872239713a] Add a check avoid 
segfault
git bisect bad d537c08b0eacdeb05835ee8c5f269b872239713a
# bad: [67bf982340d95ca98098ea050b54b4c7adb116c0] Add configure script
git bisect bad 67bf982340d95ca98098ea050b54b4c7adb116c0
[ecomar@edow500 fio]$ 
Unless stated otherwise above:
IBM United Kingdom Limited - Registered in England and Wales with number 
741598. 
Registered office: PO Box 41, North Harbour, Portsmouth, Hampshire PO6 3AU



Return-Path: <rebecca@bluestop.org>
From: Rebecca Cran <rebecca@bluestop.org>
Subject: Results from clang 7.0 analyzer (scan-build)
Message-ID: <2aebbd38-2c87-a88c-0b28-23d4d72c33cb@bluestop.org>
Date: Sat, 7 Apr 2018 17:58:17 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
To: fio <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

I ran clang 7.0's analyzer scan-build on a checkout of fio from a few 
days ago (rev 196ce5d5ff76af30cf93fd24240f12d8c4d24381, Tue Apr 3).


I've uploaded the results to 
https://bluestop.org/scan-build-2018-04-07-171241-24360-1/ in case 
anyone wants to take a look to see if it has found any real bugs.


-- 
Rebecca



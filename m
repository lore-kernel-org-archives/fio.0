Return-Path: <rebecca@bluestop.org>
From: Rebecca Cran <rebecca@bluestop.org>
Subject: Fixing CPU clock mismatch error in --cpuclock-test
Message-ID: <6ccd72db-3698-3132-2bcb-76e3a7dc958f@bluestop.org>
Date: Tue, 26 Sep 2017 11:15:23 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
To: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Hi,

I'm working on adding CPU clock support to AARCH64. But I'm getting 
messages like the following when I run --cpuclock-test :

cs: CPU clock mismatch (diff=158):
          CPU  0: TSC=13558679258196, SEQ=383792
          CPU  1: TSC=13558679258038, SEQ=383793
cs: CPU clock mismatch (diff=54):
          CPU  0: TSC=13558679258924, SEQ=383850
          CPU  1: TSC=13558679258870, SEQ=383851
cs: CPU clock mismatch (diff=52):
          CPU  0: TSC=13558679259752, SEQ=383906
          CPU  1: TSC=13558679259700, SEQ=383907
cs: Failed: 2772


Are these likely a problem with the platform, or something that can be 
fixed in fio?


-- 

Rebecca



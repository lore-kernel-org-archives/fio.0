Return-Path: <rebecca@bsdio.com>
From: Rebecca Cran <rebecca@bsdio.com>
Message-ID: <d9332e23-633e-c4c0-381b-b2fcbd983e15@bsdio.com>
Date: Tue, 26 May 2020 08:13:23 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Subject: Python scripts - /usr/bin/env python3 vs python vs python2.7
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Python scripts in fio use a variety of methods to run the python 
interpreter: t/run_fio_tests.py has "#!/usr/bin/env python3" while 
t/strided.py has "#!/usr/bin/python", and sgunmap-test.py has 
"#!/usr/bin/python2.7".


Would there any interest in converting them all to use "#!/usr/bin/env 
python3 ?


-- 
Rebecca Cran




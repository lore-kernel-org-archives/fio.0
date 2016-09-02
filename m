Return-Path: <chamarthy.raju@gmail.com>
MIME-Version: 1.0
From: Srinivasa Chamarthy <chamarthy.raju@gmail.com>
Date: Fri, 2 Sep 2016 14:38:18 +0800
Message-ID: <CABtFm2VJ+th2SAQnqtBgxz3AA9a4sDJVoN=-7M3WLF7a+G=vhw@mail.gmail.com>
Subject: Compression with unique buffers across
Content-Type: text/plain; charset=UTF-8
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

With the current implementation of FIO, for compression workloads, it
can either generate compressible buffers that are zero filled or
according to the pattern specified by buffer_pattern. Is there a way
that i can generate patterns that are unique across buffers that are
still compressible at certain % levels? i.e each of the buffer should
be unique across, but a single buffer that it writes should be of same
pattern.

--
Srinivasa R Chamarthy


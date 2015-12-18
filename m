Return-Path: <andrey.v.kuzmin@gmail.com>
MIME-Version: 1.0
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Fri, 18 Dec 2015 23:28:54 +0300
Message-ID: <CANvN+emA01TZfbBx4aU+gg5CKfy+AEX_gZW7Jz4HMHvwkdBNoQ@mail.gmail.com>
Subject: Stonewall reverse?
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Stonewall option enforces post-serialization in that a job with the
option set waits for all other jobs in the file to complete. I'm
facing a use case where the reverse might be useful: have a number of
jobs wait for the specific one to complete. Is that something that can
be done with the existing options or a new development?

Regards,
Andrey


Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:32925 "EHLO
        mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752729AbcLQKpV (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 17 Dec 2016 05:45:21 -0500
Received: by mail-qk0-f171.google.com with SMTP id t184so61599339qkd.0
        for <fio@vger.kernel.org>; Sat, 17 Dec 2016 02:45:20 -0800 (PST)
MIME-Version: 1.0
From: Saju Nair <saju.mad.nair@gmail.com>
Date: Sat, 17 Dec 2016 16:15:19 +0530
Message-ID: <CAKV1nBbOg6k3teSbeZkVJ5APhkrmNRYxOQL1UUhdOsqrLejbiQ@mail.gmail.com>
Subject: FIO -- A few basic questions on Data Integrity.
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi FIO users,
I am a new user of FIO, and had a few basic questions.
I tried to search the existing QA in archives, and have not found an
exact answer.
Apologies, for the length of the mail and also if this is already
addressed (if so, kindly point me to that archive article).

Referred to:
https://github.com/axboe/fio/issues/163
http://www.spinics.net/lists/fio/msg04104.html
http://www.spinics.net/lists/fio/msg03424.html

We are trying to do Data Integrity checks using FIO, while performing
Sequential & Random Writes/Reads.

1. Basic Write/Read and offline comparison for Data Integrity:
   a. Is it possible to perform Random Writes to a portion of the disk
(using --offset, --size options), and read back from those locations.
   b. Is it possible to force FIO to access the same LBAs during
Writes and Reads, when it is random.
   c. Is there a way to control the "randomness" using any seeds ?
   d. Is there a need to use the "state" files ?

   The intent was to get the data read back to a file, and then
compare against expected.

2. FIO comparison using *verify* options:
    We tried to do an FIO with
     --do_verify=1
     --verify=pattern
     --verify_pattern=TEST_PATTERN
     --rw=randwrite (or write - for sequential)

    In this case, again a few follow-on Questions:
    a. Does FIO perform writes completely, ie based on --size, or --runtime
        and then do the read access to verify.
        What parameters are used (for blk-size, numjobs, qdepth etc.)
during the  Reads operation.

    b. is there a way to get the results of the verify step into an
output file ?
    c. The above questions on control of random accesses still exist.
    d. We tried a run of the above kind, and the FIO run passed, ie
there were no obvious errors reported.
    e. In order to ensure that the verification was correct - we did a
2 step process:
        [similar to one of the reference articles]
        FIO#1 - with Writes (--do_verify=0, --verify_pattern=PAT1)
        FIO#2 - for read/verify (--do_verify=1, --verify_pattern=PAT2)
       and got some errors..
       But, we are not yet sure if that has flagged ALL the locations
in error or not.
       Is there a way to ascertain this ?

    f. Are there any restrictions in the usage of --num_jobs in such a check..

Regards,
- Saju

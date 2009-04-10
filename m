Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:4372 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbZDJW6H (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 10 Apr 2009 18:58:07 -0400
Received: from spaceape7.eur.corp.google.com (spaceape7.eur.corp.google.com [172.28.16.141])
	by smtp-out.google.com with ESMTP id n3AMw2WD023911
	for <fio@vger.kernel.org>; Fri, 10 Apr 2009 23:58:02 +0100
Received: from rv-out-0506.google.com (rvbf9.prod.google.com [10.140.82.9])
	by spaceape7.eur.corp.google.com with ESMTP id n3AMw03q012439
	for <fio@vger.kernel.org>; Fri, 10 Apr 2009 15:58:00 -0700
Received: by rv-out-0506.google.com with SMTP id f9so1260442rvb.13
        for <fio@vger.kernel.org>; Fri, 10 Apr 2009 15:57:59 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 10 Apr 2009 15:57:59 -0700
Message-ID: <66dfd3fe0904101557g99d6b63r5a24a84cfe01ffbf@mail.gmail.com>
Subject: Issue running random reads with verify on a raw device
From: Radha Ramachandran <radha@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,
We have a test that runs the test on a raw device say of size 100GB
> Sequential write of a pattern to the raw device with size=10GB (so even though the device is 100GB big we try to write only to the first 10GB)
> Random read and verify of the pattern to the raw device with size=10GB, (with randommap, so we maintain the bitmap of previously visited blocks)

This test almost always lands up trying to do the read beyond the
10GB. So I see this code in io_u.c:

static int get_next_free_block(struct thread_data *td, struct fio_file *f,
			       enum fio_ddir ddir, unsigned long long *b) {
...
       while ((*b) * min_bs < f->real_file_size) {   ========= This
code looks for an unvisited block within the real_file_size which in
this case is 100GB, and will exceed 10GB in a lot of cases causing the
verify to fail.


So i fixed this by checking if the block is within the real_file_size
and the io_size, so this wld work in cases where:
1. Actual file size < io_size
2. io_size < Actual file size


diff -crB io_u.c io_u.c_fixed
*** io_u.c      Fri Apr 10 15:47:02 2009
--- io_u.c_fixed        Fri Apr 10 15:48:02 2009
***************
*** 113,119 ****

        i = f->last_free_lookup;
        *b = (i * BLOCKS_PER_MAP);
!       while ((*b) * min_bs < f->real_file_size) {
                if (f->file_map[i] != (unsigned int) -1) {
                        *b += ffz(f->file_map[i]);
                        if (*b > last_block(td, f, ddir))
--- 113,120 ----

        i = f->last_free_lookup;
        *b = (i * BLOCKS_PER_MAP);
!       while (((*b) * min_bs < f->real_file_size) &&
!               ((*b) * min_bs < f->io_size)) {
                if (f->file_map[i] != (unsigned int) -1) {
                        *b += ffz(f->file_map[i]);
                        if (*b > last_block(td, f, ddir))


Is there some case I missed?
thanks
-radha

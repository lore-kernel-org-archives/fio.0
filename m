Return-Path: <fio-owner@vger.kernel.org>
Received: from bertrand.catalyst.net.nz ([202.78.240.40]:40768 "EHLO
	mail.catalyst.net.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbaJXCsg (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 23 Oct 2014 22:48:36 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.catalyst.net.nz (Postfix) with ESMTP id C969D31DA6
	for <fio@vger.kernel.org>; Fri, 24 Oct 2014 15:38:43 +1300 (NZDT)
Received: from mail.catalyst.net.nz ([127.0.0.1])
	by localhost (bertrand.catalyst.net.nz [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WyvuSgph5LEb for <fio@vger.kernel.org>;
	Fri, 24 Oct 2014 15:38:41 +1300 (NZDT)
Received: from [192.168.1.64] (122-62-5-20.jetstream.xtra.co.nz [122.62.5.20])
	(Authenticated sender: mark.kirkwood)
	by mail.catalyst.net.nz (Postfix) with ESMTPSA id 8F72231C6F
	for <fio@vger.kernel.org>; Fri, 24 Oct 2014 15:38:41 +1300 (NZDT)
Message-ID: <5449BBB3.7090109@catalyst.net.nz>
Date: Fri, 24 Oct 2014 15:38:43 +1300
From: Mark Kirkwood <mark.kirkwood@catalyst.net.nz>
MIME-Version: 1.0
Subject: fio rbd hang for block sizes > 1M
Content-Type: multipart/mixed;
 boundary="------------000201020508030205040801"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

This is a multi-part message in MIME format.
--------------000201020508030205040801
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

I stumbled across this performance testing a new ceph cluster:

Env:

Ceph 0.86-467-g317b83d (317b83dddd1a917f70838870b31931a79bdd4dd0)
Ubuntu 14.04 (3.13.0-37-generic #64-Ubuntu SMP Mon Sep 22 21:28:38 UTC 
2014 x86_64 x86_64 x86_64 GNU/Linux)
Fio fio-2.1.13-88-gb2ee7

Cmd:

$ rbd ls -l
NAME           SIZE PARENT FMT PROT LOCK
vol0          4096M          1

$ fio read-test.fio     # attached
rbd_thread: (g=0): rw=read, bs=2M-2M/2M-2M/2M-2M, ioengine=rbd, iodepth=32
fio-2.1.13-88-gb2ee7
Starting 1 process
rbd engine: RBD version: 0.1.8
Killed1 (f=1): [R(1)] [inf% done] [0KB/0KB/0KB /s] [0/0/0 iops] [eta 
1158050441d:06h:59m:33s]

Block sizes 1M usually works, 2M,4M always fail. The rbd volume should 
be written to 1st (just change read to write in workload file). Note 
that 2-4M blocksize is fine for writes!

Running the read variant under valgrind shows seveal invalid reads - 
only for these bigger block sizes, so I'm guessing they are the problem:

$ valgrind fio read-test.fio
==12519== Memcheck, a memory error detector
==12519== Copyright (C) 2002-2013, and GNU GPL'd, by Julian Seward et al.
==12519== Using Valgrind-3.10.0.SVN and LibVEX; rerun with -h for 
copyright info
==12519== Command: fio read-test.fio
==12519==
rbd_thread: (g=0): rw=read, bs=2M-2M/2M-2M/2M-2M, ioengine=rbd, iodepth=32
fio-2.1.13-88-gb2ee7
Starting 1 process
rbd engine: RBD version: 0.1.8
==12519== Thread 6:
==12519== Invalid read of size 8
==12519==    at 0x4EFA7B3: ObjectCacher::_readx(ObjectCacher::OSDRead*, 
ObjectCacher::ObjectSet*, Context*, bool) (ObjectCacher.cc:1158)
==12519==    by 0x4E965A7: 
librbd::ImageCtx::aio_read_from_cache(object_t, ceph::buffer::list*, 
unsigned long, unsigned long, Context*) (ImageCtx.cc:484)
==12519==    by 0x4EAA9FA: librbd::aio_read(librbd::ImageCtx*, 
std::vector<std::pair<unsigned long, unsigned long>, 
std::allocator<std::pair<unsigned long, unsigned long> > > const&, 
char*, ceph::buffer::list*, librbd::AioCompletion*) (internal.cc:3262)
==12519==    by 0x4EAB872: librbd::aio_read(librbd::ImageCtx*, unsigned 
long, unsigned long, char*, ceph::buffer::list*, librbd::AioCompletion*) 
(internal.cc:3135)
==12519==    by 0x4E8B737: rbd_aio_read (librbd.cc:1518)
==12519==    by 0x459D92: fio_rbd_queue (rbd.c:294)
==12519==    by 0x40D379: td_io_queue (ioengines.c:300)
==12519==    by 0x44B77E: thread_main (backend.c:781)
==12519==    by 0x81F6181: start_thread (pthread_create.c:312)
==12519==    by 0x870AFBC: clone (clone.S:111)
==12519==  Address 0x197b6fe0 is 48 bytes inside a block of size 264 free'd
==12519==    at 0x4C2C2BC: operator delete(void*) (in 
/usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==12519==    by 0x4EFA7AE: ObjectCacher::_readx(ObjectCacher::OSDRead*, 
ObjectCacher::ObjectSet*, Context*, bool) (ObjectCacher.cc:1149)
==12519==    by 0x4E965A7: 
librbd::ImageCtx::aio_read_from_cache(object_t, ceph::buffer::list*, 
unsigned long, unsigned long, Context*) (ImageCtx.cc:484)
==12519==    by 0x4EAA9FA: librbd::aio_read(librbd::ImageCtx*, 
std::vector<std::pair<unsigned long, unsigned long>, 
std::allocator<std::pair<unsigned long, unsigned long> > > const&, 
char*, ceph::buffer::list*, librbd::AioCompletion*) (internal.cc:3262)
==12519==    by 0x4EAB872: librbd::aio_read(librbd::ImageCtx*, unsigned 
long, unsigned long, char*, ceph::buffer::list*, librbd::AioCompletion*) 
(internal.cc:3135)
==12519==    by 0x4E8B737: rbd_aio_read (librbd.cc:1518)
==12519==    by 0x459D92: fio_rbd_queue (rbd.c:294)
==12519==    by 0x40D379: td_io_queue (ioengines.c:300)
==12519==    by 0x44B77E: thread_main (backend.c:781)
==12519==    by 0x81F6181: start_thread (pthread_create.c:312)
==12519==    by 0x870AFBC: clone (clone.S:111)
==12519==
==12519== Invalid read of size 8
==12519==    at 0x4EFA7CD: ObjectCacher::_readx(ObjectCacher::OSDRead*, 
ObjectCacher::ObjectSet*, Context*, bool) (ObjectCacher.h:170)
==12519==    by 0x4E965A7: 
librbd::ImageCtx::aio_read_from_cache(object_t, ceph::buffer::list*, 
unsigned long, unsigned long, Context*) (ImageCtx.cc:484)
==12519==    by 0x4EAA9FA: librbd::aio_read(librbd::ImageCtx*, 
std::vector<std::pair<unsigned long, unsigned long>, 
std::allocator<std::pair<unsigned long, unsigned long> > > const&, 
char*, ceph::buffer::list*, librbd::AioCompletion*) (internal.cc:3262)
==12519==    by 0x4EAB872: librbd::aio_read(librbd::ImageCtx*, unsigned 
long, unsigned long, char*, ceph::buffer::list*, librbd::AioCompletion*) 
(internal.cc:3135)
==12519==    by 0x4E8B737: rbd_aio_read (librbd.cc:1518)
==12519==    by 0x459D92: fio_rbd_queue (rbd.c:294)
==12519==    by 0x40D379: td_io_queue (ioengines.c:300)
==12519==    by 0x44B77E: thread_main (backend.c:781)
==12519==    by 0x81F6181: start_thread (pthread_create.c:312)
==12519==    by 0x870AFBC: clone (clone.S:111)
==12519==  Address 0x197b6fe8 is 56 bytes inside a block of size 264 free'd
==12519==    at 0x4C2C2BC: operator delete(void*) (in 
/usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==12519==    by 0x4EFA7AE: ObjectCacher::_readx(ObjectCacher::OSDRead*, 
ObjectCacher::ObjectSet*, Context*, bool) (ObjectCacher.cc:1149)
==12519==    by 0x4E965A7: 
librbd::ImageCtx::aio_read_from_cache(object_t, ceph::buffer::list*, 
unsigned long, unsigned long, Context*) (ImageCtx.cc:484)
==12519==    by 0x4EAA9FA: librbd::aio_read(librbd::ImageCtx*, 
std::vector<std::pair<unsigned long, unsigned long>, 
std::allocator<std::pair<unsigned long, unsigned long> > > const&, 
char*, ceph::buffer::list*, librbd::AioCompletion*) (internal.cc:3262)
==12519==    by 0x4EAB872: librbd::aio_read(librbd::ImageCtx*, unsigned 
long, unsigned long, char*, ceph::buffer::list*, librbd::AioCompletion*) 
(internal.cc:3135)
==12519==    by 0x4E8B737: rbd_aio_read (librbd.cc:1518)
==12519==    by 0x459D92: fio_rbd_queue (rbd.c:294)
==12519==    by 0x40D379: td_io_queue (ioengines.c:300)
==12519==    by 0x44B77E: thread_main (backend.c:781)
==12519==    by 0x81F6181: start_thread (pthread_create.c:312)
==12519==    by 0x870AFBC: clone (clone.S:111)
==12519==
==12519== Thread 18:
==12519== Invalid read of size 8
==12519==    at 0x4EFA7B3: ObjectCacher::_readx(ObjectCacher::OSDRead*, 
ObjectCacher::ObjectSet*, Context*, bool) (ObjectCacher.cc:1158)
==12519==    by 0x4F027BF: ObjectCacher::C_RetryRead::finish(int) 
(ObjectCacher.h:581)
==12519==    by 0x4E8EBE8: Context::complete(int) (Context.h:64)
==12519==    by 0x4EFF083: void finish_contexts<Context>(CephContext*, 
std::list<Context*, std::allocator<Context*> >&, int) (Context.h:120)
==12519==    by 0x4EF489C: ObjectCacher::bh_read_finish(long, sobject_t, 
unsigned long, long, unsigned long, ceph::buffer::list&, int, bool) 
(ObjectCacher.cc:805)
==12519==    by 0x4F01590: ObjectCacher::C_ReadFinish::finish(int) 
(ObjectCacher.h:504)
==12519==    by 0x4E8EBE8: Context::complete(int) (Context.h:64)
==12519==    by 0x4EB9BBC: librbd::C_Request::finish(int) 
(LibrbdWriteback.cc:54)
==12519==    by 0x4E8EBE8: Context::complete(int) (Context.h:64)
==12519==    by 0x53B64FC: librados::C_AioComplete::finish(int) 
(AioCompletionImpl.h:180)
==12519==    by 0x4E8EBE8: Context::complete(int) (Context.h:64)
==12519==    by 0x5452397: Finisher::finisher_thread_entry() 
(Finisher.cc:59)
==12519==  Address 0x1a299710 is 48 bytes inside a block of size 264 free'd
==12519==    at 0x4C2C2BC: operator delete(void*) (in 
/usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==12519==    by 0x4EFA7AE: ObjectCacher::_readx(ObjectCacher::OSDRead*, 
ObjectCacher::ObjectSet*, Context*, bool) (ObjectCacher.cc:1149)
==12519==    by 0x4F027BF: ObjectCacher::C_RetryRead::finish(int) 
(ObjectCacher.h:581)
==12519==    by 0x4E8EBE8: Context::complete(int) (Context.h:64)
==12519==    by 0x4EFF083: void finish_contexts<Context>(CephContext*, 
std::list<Context*, std::allocator<Context*> >&, int) (Context.h:120)
==12519==    by 0x4EF489C: ObjectCacher::bh_read_finish(long, sobject_t, 
unsigned long, long, unsigned long, ceph::buffer::list&, int, bool) 
(ObjectCacher.cc:805)
==12519==    by 0x4F01590: ObjectCacher::C_ReadFinish::finish(int) 
(ObjectCacher.h:504)
==12519==    by 0x4E8EBE8: Context::complete(int) (Context.h:64)
==12519==    by 0x4EB9BBC: librbd::C_Request::finish(int) 
(LibrbdWriteback.cc:54)
==12519==    by 0x4E8EBE8: Context::complete(int) (Context.h:64)
==12519==    by 0x53B64FC: librados::C_AioComplete::finish(int) 
(AioCompletionImpl.h:180)
==12519==    by 0x4E8EBE8: Context::complete(int) (Context.h:64)
==12519==
==12519== Invalid read of size 8
==12519==    at 0x4EFA7CD: ObjectCacher::_readx(ObjectCacher::OSDRead*, 
ObjectCacher::ObjectSet*, Context*, bool) (ObjectCacher.h:170)
==12519==    by 0x4F027BF: ObjectCacher::C_RetryRead::finish(int) 
(ObjectCacher.h:581)
==12519==    by 0x4E8EBE8: Context::complete(int) (Context.h:64)
==12519==    by 0x4EFF083: void finish_contexts<Context>(CephContext*, 
std::list<Context*, std::allocator<Context*> >&, int) (Context.h:120)
==12519==    by 0x4EF489C: ObjectCacher::bh_read_finish(long, sobject_t, 
unsigned long, long, unsigned long, ceph::buffer::list&, int, bool) 
(ObjectCacher.cc:805)
==12519==    by 0x4F01590: ObjectCacher::C_ReadFinish::finish(int) 
(ObjectCacher.h:504)
==12519==    by 0x4E8EBE8: Context::complete(int) (Context.h:64)
==12519==    by 0x4EB9BBC: librbd::C_Request::finish(int) 
(LibrbdWriteback.cc:54)
==12519==    by 0x4E8EBE8: Context::complete(int) (Context.h:64)
==12519==    by 0x53B64FC: librados::C_AioComplete::finish(int) 
(AioCompletionImpl.h:180)
==12519==    by 0x4E8EBE8: Context::complete(int) (Context.h:64)
==12519==    by 0x5452397: Finisher::finisher_thread_entry() 
(Finisher.cc:59)
==12519==  Address 0x1a299718 is 56 bytes inside a block of size 264 free'd
==12519==    at 0x4C2C2BC: operator delete(void*) (in 
/usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==12519==    by 0x4EFA7AE: ObjectCacher::_readx(ObjectCacher::OSDRead*, 
ObjectCacher::ObjectSet*, Context*, bool) (ObjectCacher.cc:1149)
==12519==    by 0x4F027BF: ObjectCacher::C_RetryRead::finish(int) 
(ObjectCacher.h:581)
==12519==    by 0x4E8EBE8: Context::complete(int) (Context.h:64)
==12519==    by 0x4EFF083: void finish_contexts<Context>(CephContext*, 
std::list<Context*, std::allocator<Context*> >&, int) (Context.h:120)
==12519==    by 0x4EF489C: ObjectCacher::bh_read_finish(long, sobject_t, 
unsigned long, long, unsigned long, ceph::buffer::list&, int, bool) 
(ObjectCacher.cc:805)
==12519==    by 0x4F01590: ObjectCacher::C_ReadFinish::finish(int) 
(ObjectCacher.h:504)
==12519==    by 0x4E8EBE8: Context::complete(int) (Context.h:64)
==12519==    by 0x4EB9BBC: librbd::C_Request::finish(int) 
(LibrbdWriteback.cc:54)
==12519==    by 0x4E8EBE8: Context::complete(int) (Context.h:64)
==12519==    by 0x53B64FC: librados::C_AioComplete::finish(int) 
(AioCompletionImpl.h:180)
==12519==    by 0x4E8EBE8: Context::complete(int) (Context.h:64)
==12519==

--------------000201020508030205040801
Content-Type: text/plain; charset=UTF-8;
 name="read-test.fio"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="read-test.fio"

IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIwojIEV4YW1wbGUgdGVzdCBmb3IgdGhlIFJCRCBlbmdpbmUuCiMK
IyBGcm9tIGh0dHA6Ly90ZWxla29tY2xvdWQuZ2l0aHViLmlvL2NlcGgvMjAxNC8wMi8yNi9j
ZXBoLXBlcmZvcm1hbmNlLWFuYWx5c2lzX2Zpb19yYmQuaHRtbAojCiMgUnVucyBhIDRrIHJh
bmRvbSB3cml0ZSB0ZXN0IGFnYWlucyBhIFJCRCB2aWEgbGlicmJkCiMKIyBOT1RFOiBNYWtl
IHN1cmUgeW91IGhhdmUgZWl0aGVyIGEgUkJEIG5hbWVkICd2b2x0ZXN0JyBvciBjaGFuZ2UK
IyAgICAgICB0aGUgcmJkbmFtZSBwYXJhbWV0ZXIuCiMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMKW2dsb2Jh
bF0KI2xvZ2dpbmcKI3dyaXRlX2lvcHNfbG9nPXdyaXRlX2lvcHNfbG9nCiN3cml0ZV9id19s
b2c9d3JpdGVfYndfbG9nCiN3cml0ZV9sYXRfbG9nPXdyaXRlX2xhdF9sb2cKaW9lbmdpbmU9
cmJkCmNsaWVudG5hbWU9YWRtaW4KcG9vbD1yYmQKcmJkbmFtZT12b2wwCmludmFsaWRhdGU9
MCAgICAjIG1hbmRhdG9yeQpydz1yZWFkCmJzPTJNCgpbcmJkX3RocmVhZF0KaW9kZXB0aD0z
Mgo=
--------------000201020508030205040801--

Return-Path: <axboe@kernel.dk>
Message-ID: <5449E50E.7000808@kernel.dk>
Date: Thu, 23 Oct 2014 23:35:10 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio rbd hang for block sizes > 1M
References: <5449BBB3.7090109@catalyst.net.nz>
In-Reply-To: <5449BBB3.7090109@catalyst.net.nz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Mark Kirkwood <mark.kirkwood@catalyst.net.nz>, fio@vger.kernel.org
Cc: "d.gollub@telekom.de >> Daniel Gollub" <d.gollub@telekom.de>, "xan.peng" <xanpeng@gmail.com>
List-ID: <fio@vger.kernel.org>

CC'ing relevant parties, leaving email intact.

On 2014-10-23 20:38, Mark Kirkwood wrote:
> I stumbled across this performance testing a new ceph cluster:
>
> Env:
>
> Ceph 0.86-467-g317b83d (317b83dddd1a917f70838870b31931a79bdd4dd0)
> Ubuntu 14.04 (3.13.0-37-generic #64-Ubuntu SMP Mon Sep 22 21:28:38 UTC
> 2014 x86_64 x86_64 x86_64 GNU/Linux)
> Fio fio-2.1.13-88-gb2ee7
>
> Cmd:
>
> $ rbd ls -l
> NAME           SIZE PARENT FMT PROT LOCK
> vol0          4096M          1
>
> $ fio read-test.fio     # attached
> rbd_thread: (g=0): rw=read, bs=2M-2M/2M-2M/2M-2M, ioengine=rbd, iodepth=32
> fio-2.1.13-88-gb2ee7
> Starting 1 process
> rbd engine: RBD version: 0.1.8
> Killed1 (f=1): [R(1)] [inf% done] [0KB/0KB/0KB /s] [0/0/0 iops] [eta
> 1158050441d:06h:59m:33s]
>
> Block sizes 1M usually works, 2M,4M always fail. The rbd volume should
> be written to 1st (just change read to write in workload file). Note
> that 2-4M blocksize is fine for writes!
>
> Running the read variant under valgrind shows seveal invalid reads -
> only for these bigger block sizes, so I'm guessing they are the problem:
>
> $ valgrind fio read-test.fio
> ==12519== Memcheck, a memory error detector
> ==12519== Copyright (C) 2002-2013, and GNU GPL'd, by Julian Seward et al.
> ==12519== Using Valgrind-3.10.0.SVN and LibVEX; rerun with -h for
> copyright info
> ==12519== Command: fio read-test.fio
> ==12519==
> rbd_thread: (g=0): rw=read, bs=2M-2M/2M-2M/2M-2M, ioengine=rbd, iodepth=32
> fio-2.1.13-88-gb2ee7
> Starting 1 process
> rbd engine: RBD version: 0.1.8
> ==12519== Thread 6:
> ==12519== Invalid read of size 8
> ==12519==    at 0x4EFA7B3: ObjectCacher::_readx(ObjectCacher::OSDRead*,
> ObjectCacher::ObjectSet*, Context*, bool) (ObjectCacher.cc:1158)
> ==12519==    by 0x4E965A7:
> librbd::ImageCtx::aio_read_from_cache(object_t, ceph::buffer::list*,
> unsigned long, unsigned long, Context*) (ImageCtx.cc:484)
> ==12519==    by 0x4EAA9FA: librbd::aio_read(librbd::ImageCtx*,
> std::vector<std::pair<unsigned long, unsigned long>,
> std::allocator<std::pair<unsigned long, unsigned long> > > const&,
> char*, ceph::buffer::list*, librbd::AioCompletion*) (internal.cc:3262)
> ==12519==    by 0x4EAB872: librbd::aio_read(librbd::ImageCtx*, unsigned
> long, unsigned long, char*, ceph::buffer::list*, librbd::AioCompletion*)
> (internal.cc:3135)
> ==12519==    by 0x4E8B737: rbd_aio_read (librbd.cc:1518)
> ==12519==    by 0x459D92: fio_rbd_queue (rbd.c:294)
> ==12519==    by 0x40D379: td_io_queue (ioengines.c:300)
> ==12519==    by 0x44B77E: thread_main (backend.c:781)
> ==12519==    by 0x81F6181: start_thread (pthread_create.c:312)
> ==12519==    by 0x870AFBC: clone (clone.S:111)
> ==12519==  Address 0x197b6fe0 is 48 bytes inside a block of size 264 free'd
> ==12519==    at 0x4C2C2BC: operator delete(void*) (in
> /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
> ==12519==    by 0x4EFA7AE: ObjectCacher::_readx(ObjectCacher::OSDRead*,
> ObjectCacher::ObjectSet*, Context*, bool) (ObjectCacher.cc:1149)
> ==12519==    by 0x4E965A7:
> librbd::ImageCtx::aio_read_from_cache(object_t, ceph::buffer::list*,
> unsigned long, unsigned long, Context*) (ImageCtx.cc:484)
> ==12519==    by 0x4EAA9FA: librbd::aio_read(librbd::ImageCtx*,
> std::vector<std::pair<unsigned long, unsigned long>,
> std::allocator<std::pair<unsigned long, unsigned long> > > const&,
> char*, ceph::buffer::list*, librbd::AioCompletion*) (internal.cc:3262)
> ==12519==    by 0x4EAB872: librbd::aio_read(librbd::ImageCtx*, unsigned
> long, unsigned long, char*, ceph::buffer::list*, librbd::AioCompletion*)
> (internal.cc:3135)
> ==12519==    by 0x4E8B737: rbd_aio_read (librbd.cc:1518)
> ==12519==    by 0x459D92: fio_rbd_queue (rbd.c:294)
> ==12519==    by 0x40D379: td_io_queue (ioengines.c:300)
> ==12519==    by 0x44B77E: thread_main (backend.c:781)
> ==12519==    by 0x81F6181: start_thread (pthread_create.c:312)
> ==12519==    by 0x870AFBC: clone (clone.S:111)
> ==12519==
> ==12519== Invalid read of size 8
> ==12519==    at 0x4EFA7CD: ObjectCacher::_readx(ObjectCacher::OSDRead*,
> ObjectCacher::ObjectSet*, Context*, bool) (ObjectCacher.h:170)
> ==12519==    by 0x4E965A7:
> librbd::ImageCtx::aio_read_from_cache(object_t, ceph::buffer::list*,
> unsigned long, unsigned long, Context*) (ImageCtx.cc:484)
> ==12519==    by 0x4EAA9FA: librbd::aio_read(librbd::ImageCtx*,
> std::vector<std::pair<unsigned long, unsigned long>,
> std::allocator<std::pair<unsigned long, unsigned long> > > const&,
> char*, ceph::buffer::list*, librbd::AioCompletion*) (internal.cc:3262)
> ==12519==    by 0x4EAB872: librbd::aio_read(librbd::ImageCtx*, unsigned
> long, unsigned long, char*, ceph::buffer::list*, librbd::AioCompletion*)
> (internal.cc:3135)
> ==12519==    by 0x4E8B737: rbd_aio_read (librbd.cc:1518)
> ==12519==    by 0x459D92: fio_rbd_queue (rbd.c:294)
> ==12519==    by 0x40D379: td_io_queue (ioengines.c:300)
> ==12519==    by 0x44B77E: thread_main (backend.c:781)
> ==12519==    by 0x81F6181: start_thread (pthread_create.c:312)
> ==12519==    by 0x870AFBC: clone (clone.S:111)
> ==12519==  Address 0x197b6fe8 is 56 bytes inside a block of size 264 free'd
> ==12519==    at 0x4C2C2BC: operator delete(void*) (in
> /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
> ==12519==    by 0x4EFA7AE: ObjectCacher::_readx(ObjectCacher::OSDRead*,
> ObjectCacher::ObjectSet*, Context*, bool) (ObjectCacher.cc:1149)
> ==12519==    by 0x4E965A7:
> librbd::ImageCtx::aio_read_from_cache(object_t, ceph::buffer::list*,
> unsigned long, unsigned long, Context*) (ImageCtx.cc:484)
> ==12519==    by 0x4EAA9FA: librbd::aio_read(librbd::ImageCtx*,
> std::vector<std::pair<unsigned long, unsigned long>,
> std::allocator<std::pair<unsigned long, unsigned long> > > const&,
> char*, ceph::buffer::list*, librbd::AioCompletion*) (internal.cc:3262)
> ==12519==    by 0x4EAB872: librbd::aio_read(librbd::ImageCtx*, unsigned
> long, unsigned long, char*, ceph::buffer::list*, librbd::AioCompletion*)
> (internal.cc:3135)
> ==12519==    by 0x4E8B737: rbd_aio_read (librbd.cc:1518)
> ==12519==    by 0x459D92: fio_rbd_queue (rbd.c:294)
> ==12519==    by 0x40D379: td_io_queue (ioengines.c:300)
> ==12519==    by 0x44B77E: thread_main (backend.c:781)
> ==12519==    by 0x81F6181: start_thread (pthread_create.c:312)
> ==12519==    by 0x870AFBC: clone (clone.S:111)
> ==12519==
> ==12519== Thread 18:
> ==12519== Invalid read of size 8
> ==12519==    at 0x4EFA7B3: ObjectCacher::_readx(ObjectCacher::OSDRead*,
> ObjectCacher::ObjectSet*, Context*, bool) (ObjectCacher.cc:1158)
> ==12519==    by 0x4F027BF: ObjectCacher::C_RetryRead::finish(int)
> (ObjectCacher.h:581)
> ==12519==    by 0x4E8EBE8: Context::complete(int) (Context.h:64)
> ==12519==    by 0x4EFF083: void finish_contexts<Context>(CephContext*,
> std::list<Context*, std::allocator<Context*> >&, int) (Context.h:120)
> ==12519==    by 0x4EF489C: ObjectCacher::bh_read_finish(long, sobject_t,
> unsigned long, long, unsigned long, ceph::buffer::list&, int, bool)
> (ObjectCacher.cc:805)
> ==12519==    by 0x4F01590: ObjectCacher::C_ReadFinish::finish(int)
> (ObjectCacher.h:504)
> ==12519==    by 0x4E8EBE8: Context::complete(int) (Context.h:64)
> ==12519==    by 0x4EB9BBC: librbd::C_Request::finish(int)
> (LibrbdWriteback.cc:54)
> ==12519==    by 0x4E8EBE8: Context::complete(int) (Context.h:64)
> ==12519==    by 0x53B64FC: librados::C_AioComplete::finish(int)
> (AioCompletionImpl.h:180)
> ==12519==    by 0x4E8EBE8: Context::complete(int) (Context.h:64)
> ==12519==    by 0x5452397: Finisher::finisher_thread_entry()
> (Finisher.cc:59)
> ==12519==  Address 0x1a299710 is 48 bytes inside a block of size 264 free'd
> ==12519==    at 0x4C2C2BC: operator delete(void*) (in
> /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
> ==12519==    by 0x4EFA7AE: ObjectCacher::_readx(ObjectCacher::OSDRead*,
> ObjectCacher::ObjectSet*, Context*, bool) (ObjectCacher.cc:1149)
> ==12519==    by 0x4F027BF: ObjectCacher::C_RetryRead::finish(int)
> (ObjectCacher.h:581)
> ==12519==    by 0x4E8EBE8: Context::complete(int) (Context.h:64)
> ==12519==    by 0x4EFF083: void finish_contexts<Context>(CephContext*,
> std::list<Context*, std::allocator<Context*> >&, int) (Context.h:120)
> ==12519==    by 0x4EF489C: ObjectCacher::bh_read_finish(long, sobject_t,
> unsigned long, long, unsigned long, ceph::buffer::list&, int, bool)
> (ObjectCacher.cc:805)
> ==12519==    by 0x4F01590: ObjectCacher::C_ReadFinish::finish(int)
> (ObjectCacher.h:504)
> ==12519==    by 0x4E8EBE8: Context::complete(int) (Context.h:64)
> ==12519==    by 0x4EB9BBC: librbd::C_Request::finish(int)
> (LibrbdWriteback.cc:54)
> ==12519==    by 0x4E8EBE8: Context::complete(int) (Context.h:64)
> ==12519==    by 0x53B64FC: librados::C_AioComplete::finish(int)
> (AioCompletionImpl.h:180)
> ==12519==    by 0x4E8EBE8: Context::complete(int) (Context.h:64)
> ==12519==
> ==12519== Invalid read of size 8
> ==12519==    at 0x4EFA7CD: ObjectCacher::_readx(ObjectCacher::OSDRead*,
> ObjectCacher::ObjectSet*, Context*, bool) (ObjectCacher.h:170)
> ==12519==    by 0x4F027BF: ObjectCacher::C_RetryRead::finish(int)
> (ObjectCacher.h:581)
> ==12519==    by 0x4E8EBE8: Context::complete(int) (Context.h:64)
> ==12519==    by 0x4EFF083: void finish_contexts<Context>(CephContext*,
> std::list<Context*, std::allocator<Context*> >&, int) (Context.h:120)
> ==12519==    by 0x4EF489C: ObjectCacher::bh_read_finish(long, sobject_t,
> unsigned long, long, unsigned long, ceph::buffer::list&, int, bool)
> (ObjectCacher.cc:805)
> ==12519==    by 0x4F01590: ObjectCacher::C_ReadFinish::finish(int)
> (ObjectCacher.h:504)
> ==12519==    by 0x4E8EBE8: Context::complete(int) (Context.h:64)
> ==12519==    by 0x4EB9BBC: librbd::C_Request::finish(int)
> (LibrbdWriteback.cc:54)
> ==12519==    by 0x4E8EBE8: Context::complete(int) (Context.h:64)
> ==12519==    by 0x53B64FC: librados::C_AioComplete::finish(int)
> (AioCompletionImpl.h:180)
> ==12519==    by 0x4E8EBE8: Context::complete(int) (Context.h:64)
> ==12519==    by 0x5452397: Finisher::finisher_thread_entry()
> (Finisher.cc:59)
> ==12519==  Address 0x1a299718 is 56 bytes inside a block of size 264 free'd
> ==12519==    at 0x4C2C2BC: operator delete(void*) (in
> /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
> ==12519==    by 0x4EFA7AE: ObjectCacher::_readx(ObjectCacher::OSDRead*,
> ObjectCacher::ObjectSet*, Context*, bool) (ObjectCacher.cc:1149)
> ==12519==    by 0x4F027BF: ObjectCacher::C_RetryRead::finish(int)
> (ObjectCacher.h:581)
> ==12519==    by 0x4E8EBE8: Context::complete(int) (Context.h:64)
> ==12519==    by 0x4EFF083: void finish_contexts<Context>(CephContext*,
> std::list<Context*, std::allocator<Context*> >&, int) (Context.h:120)
> ==12519==    by 0x4EF489C: ObjectCacher::bh_read_finish(long, sobject_t,
> unsigned long, long, unsigned long, ceph::buffer::list&, int, bool)
> (ObjectCacher.cc:805)
> ==12519==    by 0x4F01590: ObjectCacher::C_ReadFinish::finish(int)
> (ObjectCacher.h:504)
> ==12519==    by 0x4E8EBE8: Context::complete(int) (Context.h:64)
> ==12519==    by 0x4EB9BBC: librbd::C_Request::finish(int)
> (LibrbdWriteback.cc:54)
> ==12519==    by 0x4E8EBE8: Context::complete(int) (Context.h:64)
> ==12519==    by 0x53B64FC: librados::C_AioComplete::finish(int)
> (AioCompletionImpl.h:180)
> ==12519==    by 0x4E8EBE8: Context::complete(int) (Context.h:64)
> ==12519==


-- 
Jens Axboe



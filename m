Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:35358 "EHLO
        mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751693AbcLOHbu (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 15 Dec 2016 02:31:50 -0500
Received: by mail-vk0-f44.google.com with SMTP id w194so65218959vkw.2
        for <fio@vger.kernel.org>; Wed, 14 Dec 2016 23:30:16 -0800 (PST)
MIME-Version: 1.0
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 15 Dec 2016 07:30:14 +0000
Message-ID: <CALjAwxg7=ZOqsbZQ-XWf+F0J7g2NTDU-BBwp1Au4dYXvNWCwEg@mail.gmail.com>
Subject: Potential data races in fio as reported by ThreadSanitizer
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

While running a clang ThreadSanitizer
(https://github.com/google/sanitizers/wiki/ThreadSanitizerAlgorithm )
compiled fio a number of potential (as opposed to actually happened)
data races are reported (included below). Many of these are only to do
with printing ETA information but with modern compilers there's the
"races are undefined behaviour" argument.

A description of a ThreadSanitizer report can be found on
https://github.com/google/sanitizers/wiki/ThreadSanitizerReportFormat
the output I saw is below:

./fio --thread --ioengine=null --read_iolog wait.fiolog --name=replay
replay: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=null, iodepth=1
fio-2.15-25-gea8d
Starting 1 thread
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 8 at 0x00000162d7e0 by thread T1:
    #0 helper_should_exit helper_thread.c:51 (fio+0x00000052e7b6)
    #1 update_io_ticks diskutil.c:125 (fio+0x0000005392e1)
    #2 helper_thread_main helper_thread.c:108 (fio+0x00000052eb09)

  Previous write of size 8 at 0x00000162d7e0 by main thread:
    #0 helper_thread_create helper_thread.c:160 (fio+0x00000052e938)
    #1 fio_backend backend.c:2396 (fio+0x00000051ab8d)
    #2 main fio.c:65 (fio+0x000000424520)

  Location is global '<null>' at 0x000000000000 (fio+0x00000162d7e0)

  Thread T1 (tid=54799, running) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 helper_thread_create helper_thread.c:154 (fio+0x00000052e90f)
    #2 fio_backend backend.c:2396 (fio+0x00000051ab8d)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race helper_thread.c:51 in helper_should_exit
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 8 at 0x000001626680 by thread T1:
    #0 memcpy clang-3.9/llvm/projects/compiler-rt/lib/tsan/../sanitizer_common/sanitizer_common_interceptors.inc:598
(fio+0x000000454b6b)
    #1 fill_start_time time.c:167 (fio+0x0000004dd89f)
    #2 calc_thread_status eta.c:380 (fio+0x0000004e413d)
    #3 get_jobs_eta eta.c:619 (fio+0x0000004e6466)
    #4 print_thread_status eta.c:633 (fio+0x0000004e6466)
    #5 helper_thread_main helper_thread.c:128 (fio+0x00000052eb97)

  Previous write of size 8 at 0x000001626680 by main thread:
    #0 __fio_gettime gettime.c:163 (fio+0x0000004c2f9d)
    #1 fio_gettime gettime.c:226 (fio+0x0000004c2ed2)
    #2 set_genesis_time time.c:151 (fio+0x0000004dd7f6)
    #3 run_threads backend.c:2185 (fio+0x00000051b1c5)
    #4 fio_backend backend.c:2401 (fio+0x00000051b1c5)
    #5 main fio.c:65 (fio+0x000000424520)

  Location is global '<null>' at 0x000000000000 (fio+0x000001626680)

  Thread T1 (tid=54799, running) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 helper_thread_create helper_thread.c:154 (fio+0x00000052e90f)
    #2 fio_backend backend.c:2396 (fio+0x00000051ab8d)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race time.c:167 in fill_start_time
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 8 at 0x000001626688 by thread T1:
    #0 memcpy clang-3.9/llvm/projects/compiler-rt/lib/tsan/../sanitizer_common/sanitizer_common_interceptors.inc:598
(fio+0x000000454b6b)
    #1 fill_start_time time.c:167 (fio+0x0000004dd89f)
    #2 calc_thread_status eta.c:380 (fio+0x0000004e413d)
    #3 get_jobs_eta eta.c:619 (fio+0x0000004e6466)
    #4 print_thread_status eta.c:633 (fio+0x0000004e6466)
    #5 helper_thread_main helper_thread.c:128 (fio+0x00000052eb97)

  Previous write of size 8 at 0x000001626688 by main thread:
    #0 __fio_gettime gettime.c:164 (fio+0x0000004c2fc9)
    #1 fio_gettime gettime.c:226 (fio+0x0000004c2ed2)
    #2 set_genesis_time time.c:151 (fio+0x0000004dd7f6)
    #3 run_threads backend.c:2185 (fio+0x00000051b1c5)
    #4 fio_backend backend.c:2401 (fio+0x00000051b1c5)
    #5 main fio.c:65 (fio+0x000000424520)

  Location is global '<null>' at 0x000000000000 (fio+0x000001626688)

  Thread T1 (tid=54799, running) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 helper_thread_create helper_thread.c:154 (fio+0x00000052e90f)
    #2 fio_backend backend.c:2396 (fio+0x00000051ab8d)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race time.c:167 in fill_start_time
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 4 at 0x7f406e9b60a8 by thread T1:
    #0 calc_thread_status eta.c:417 (fio+0x0000004e4490)
    #1 get_jobs_eta eta.c:619 (fio+0x0000004e6466)
    #2 print_thread_status eta.c:633 (fio+0x0000004e6466)
    #3 helper_thread_main helper_thread.c:128 (fio+0x00000052eb97)

  Previous write of size 4 at 0x7f406e9b60a8 by thread T2:
    #0 read_iolog2 iolog.c:487 (fio+0x00000051676e)
    #1 init_iolog_read iolog.c:524 (fio+0x00000051676e)
    #2 init_iolog iolog.c:587 (fio+0x00000051676e)
    #3 thread_main backend.c:1612 (fio+0x00000051c5ab)

  Thread T1 (tid=54799, running) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 helper_thread_create helper_thread.c:154 (fio+0x00000052e90f)
    #2 fio_backend backend.c:2396 (fio+0x00000051ab8d)
    #3 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, running) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race eta.c:417 in calc_thread_status
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 4 at 0x7f406e9c30f8 by thread T1:
    #0 calc_thread_status eta.c:424 (fio+0x0000004e46a9)
    #1 get_jobs_eta eta.c:619 (fio+0x0000004e6466)
    #2 print_thread_status eta.c:633 (fio+0x0000004e6466)
    #3 helper_thread_main helper_thread.c:128 (fio+0x00000052eb97)

  Previous write of size 4 at 0x7f406e9c30f8 by thread T2:
    #0 td_io_open_file ioengines.c:435 (fio+0x0000004c5d8d)
    #1 ipo_special iolog.c:117 (fio+0x000000514efc)
    #2 read_iolog_get iolog.c:148 (fio+0x000000514efc)
    #3 get_io_u io_u.c:1623 (fio+0x0000004f1df4)
    #4 do_io backend.c:914 (fio+0x000000520319)
    #5 thread_main backend.c:1700 (fio+0x000000520319)

  Thread T1 (tid=54799, running) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 helper_thread_create helper_thread.c:154 (fio+0x00000052e90f)
    #2 fio_backend backend.c:2396 (fio+0x00000051ab8d)
    #3 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, running) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race eta.c:424 in calc_thread_status
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 1 at 0x000001626720 by thread T1:
    #0 check_str_update eta.c:37 (fio+0x0000004e4d3f)
    #1 calc_thread_status eta.c:438 (fio+0x0000004e4d3f)
    #2 get_jobs_eta eta.c:619 (fio+0x0000004e6466)
    #3 print_thread_status eta.c:633 (fio+0x0000004e6466)
    #4 helper_thread_main helper_thread.c:128 (fio+0x00000052eb97)

  Previous write of size 1 at 0x000001626720 by main thread:
    #0 print_status_init eta.c:642 (fio+0x0000004e64c2)
    #1 run_threads backend.c:2145 (fio+0x00000051b08b)
    #2 fio_backend backend.c:2401 (fio+0x00000051b08b)
    #3 main fio.c:65 (fio+0x000000424520)

  Location is global '<null>' at 0x000000000000 (fio+0x000001626720)

  Thread T1 (tid=54799, running) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 helper_thread_create helper_thread.c:154 (fio+0x00000052e90f)
    #2 fio_backend backend.c:2396 (fio+0x00000051ab8d)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race eta.c:37 in check_str_update
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Write of size 1 at 0x000001627730 by thread T1:
    #0 update_condensed_str eta.c:20 (fio+0x0000004e4f47)
    #1 check_str_update eta.c:115 (fio+0x0000004e4f47)
    #2 calc_thread_status eta.c:438 (fio+0x0000004e4f47)
    #3 get_jobs_eta eta.c:619 (fio+0x0000004e6466)
    #4 print_thread_status eta.c:633 (fio+0x0000004e6466)
    #5 helper_thread_main helper_thread.c:128 (fio+0x00000052eb97)

  Previous write of size 1 at 0x000001627730 by main thread:
    #0 update_condensed_str eta.c:20 (fio+0x0000004e6507)
    #1 print_status_init eta.c:643 (fio+0x0000004e6507)
    #2 run_threads backend.c:2145 (fio+0x00000051b08b)
    #3 fio_backend backend.c:2401 (fio+0x00000051b08b)
    #4 main fio.c:65 (fio+0x000000424520)

  Location is global '<null>' at 0x000000000000 (fio+0x000001627730)

  Thread T1 (tid=54799, running) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 helper_thread_create helper_thread.c:154 (fio+0x00000052e90f)
    #2 fio_backend backend.c:2396 (fio+0x00000051ab8d)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race eta.c:20 in update_condensed_str
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Write of size 1 at 0x000001627734 by thread T1:
    #0 update_condensed_str eta.c:29 (fio+0x0000004e4fc7)
    #1 check_str_update eta.c:115 (fio+0x0000004e4fc7)
    #2 calc_thread_status eta.c:438 (fio+0x0000004e4fc7)
    #3 get_jobs_eta eta.c:619 (fio+0x0000004e6466)
    #4 print_thread_status eta.c:633 (fio+0x0000004e6466)
    #5 helper_thread_main helper_thread.c:128 (fio+0x00000052eb97)

  Previous write of size 1 at 0x000001627734 by main thread:
    #0 update_condensed_str eta.c:29 (fio+0x0000004e657c)
    #1 print_status_init eta.c:643 (fio+0x0000004e657c)
    #2 run_threads backend.c:2145 (fio+0x00000051b08b)
    #3 fio_backend backend.c:2401 (fio+0x00000051b08b)
    #4 main fio.c:65 (fio+0x000000424520)

  Location is global '<null>' at 0x000000000000 (fio+0x000001627734)

  Thread T1 (tid=54799, running) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 helper_thread_create helper_thread.c:154 (fio+0x00000052e90f)
    #2 fio_backend backend.c:2396 (fio+0x00000051ab8d)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race eta.c:29 in update_condensed_str
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 8 at 0x7f406e9c3778 by thread T1:
    #0 calc_thread_status eta.c:445 (fio+0x0000004e4ff3)
    #1 get_jobs_eta eta.c:619 (fio+0x0000004e6466)
    #2 print_thread_status eta.c:633 (fio+0x0000004e6466)
    #3 helper_thread_main helper_thread.c:128 (fio+0x00000052eb97)

  Previous write of size 8 at 0x7f406e9c3778 by thread T2:
    #0 io_completed io_u.c:1856 (fio+0x0000004f2eab)
    #1 io_u_sync_complete io_u.c:1938 (fio+0x0000004f29e6)
    #2 io_queue_event backend.c:519 (fio+0x00000051a5bc)
    #3 do_io backend.c:995 (fio+0x000000520d43)
    #4 thread_main backend.c:1700 (fio+0x000000520d43)

  Thread T1 (tid=54799, running) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 helper_thread_create helper_thread.c:154 (fio+0x00000052e90f)
    #2 fio_backend backend.c:2396 (fio+0x00000051ab8d)
    #3 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, running) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race eta.c:445 in calc_thread_status
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 8 at 0x7f406e9c3748 by thread T1:
    #0 calc_thread_status eta.c:449 (fio+0x0000004e508c)
    #1 get_jobs_eta eta.c:619 (fio+0x0000004e6466)
    #2 print_thread_status eta.c:633 (fio+0x0000004e6466)
    #3 helper_thread_main helper_thread.c:128 (fio+0x00000052eb97)

  Previous write of size 8 at 0x7f406e9c3748 by thread T2:
    #0 io_completed io_u.c:1854 (fio+0x0000004f2e5f)
    #1 io_u_sync_complete io_u.c:1938 (fio+0x0000004f29e6)
    #2 io_queue_event backend.c:519 (fio+0x00000051a5bc)
    #3 do_io backend.c:995 (fio+0x000000520d43)
    #4 thread_main backend.c:1700 (fio+0x000000520d43)

  Thread T1 (tid=54799, running) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 helper_thread_create helper_thread.c:154 (fio+0x00000052e90f)
    #2 fio_backend backend.c:2396 (fio+0x00000051ab8d)
    #3 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, running) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race eta.c:449 in calc_thread_status
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 8 at 0x7f406e9c3818 by thread T1:
    #0 mtime_since gettime.c:415 (fio+0x0000004c3e5e)
    #1 mtime_since_now gettime.c:436 (fio+0x0000004c3e5e)
    #2 thread_eta eta.c:161 (fio+0x0000004e46f9)
    #3 calc_thread_status eta.c:434 (fio+0x0000004e46f9)
    #4 get_jobs_eta eta.c:619 (fio+0x0000004e6466)
    #5 print_thread_status eta.c:633 (fio+0x0000004e6466)
    #6 helper_thread_main helper_thread.c:128 (fio+0x00000052eb97)

  Previous write of size 8 at 0x7f406e9c3818 by thread T2:
    #0 __fio_gettime gettime.c:163 (fio+0x0000004c2f9d)
    #1 fio_gettime gettime.c:226 (fio+0x0000004c2ed2)
    #2 set_epoch_time time.c:156 (fio+0x0000004dd822)
    #3 thread_main backend.c:1664 (fio+0x00000051e309)

  Thread T1 (tid=54799, running) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 helper_thread_create helper_thread.c:154 (fio+0x00000052e90f)
    #2 fio_backend backend.c:2396 (fio+0x00000051ab8d)
    #3 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, running) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race gettime.c:415 in mtime_since
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 8 at 0x7f406e9c3820 by thread T1:
    #0 mtime_since gettime.c:416 (fio+0x0000004c3e6e)
    #1 mtime_since_now gettime.c:436 (fio+0x0000004c3e6e)
    #2 thread_eta eta.c:161 (fio+0x0000004e46f9)
    #3 calc_thread_status eta.c:434 (fio+0x0000004e46f9)
    #4 get_jobs_eta eta.c:619 (fio+0x0000004e6466)
    #5 print_thread_status eta.c:633 (fio+0x0000004e6466)
    #6 helper_thread_main helper_thread.c:128 (fio+0x00000052eb97)

  Previous write of size 8 at 0x7f406e9c3820 by thread T2:
    #0 __fio_gettime gettime.c:164 (fio+0x0000004c2fc9)
    #1 fio_gettime gettime.c:226 (fio+0x0000004c2ed2)
    #2 set_epoch_time time.c:156 (fio+0x0000004dd822)
    #3 thread_main backend.c:1664 (fio+0x00000051e309)

  Thread T1 (tid=54799, running) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 helper_thread_create helper_thread.c:154 (fio+0x00000052e90f)
    #2 fio_backend backend.c:2396 (fio+0x00000051ab8d)
    #3 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, running) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race gettime.c:416 in mtime_since
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 8 at 0x7f406e9c3700 by thread T1:
    #0 thread_eta eta.c:164 (fio+0x0000004e4747)
    #1 calc_thread_status eta.c:434 (fio+0x0000004e4747)
    #2 get_jobs_eta eta.c:619 (fio+0x0000004e6466)
    #3 print_thread_status eta.c:633 (fio+0x0000004e6466)
    #4 helper_thread_main helper_thread.c:128 (fio+0x00000052eb97)

  Previous write of size 8 at 0x7f406e9c3700 by thread T2:
    #0 queue_io_piece iolog.c:30 (fio+0x0000005166ba)
    #1 read_iolog2 iolog.c:471 (fio+0x0000005166ba)
    #2 init_iolog_read iolog.c:524 (fio+0x0000005166ba)
    #3 init_iolog iolog.c:587 (fio+0x0000005166ba)
    #4 thread_main backend.c:1612 (fio+0x00000051c5ab)

  Thread T1 (tid=54799, running) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 helper_thread_create helper_thread.c:154 (fio+0x00000052e90f)
    #2 fio_backend backend.c:2396 (fio+0x00000051ab8d)
    #3 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, running) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race eta.c:164 in thread_eta
==================
==================1)] [100.0% done] [0KB/0KB/0KB /s] [0/0/0 iops] [eta 00m:00s]
WARNING: ThreadSanitizer: data race (pid=54796)
  Write of size 4 at 0x7f406e9c31d4 by thread T2:
    #0 td_set_runstate libfio.c:217 (fio+0x000000523268)
    #1 thread_main backend.c:1778 (fio+0x00000051e44e)

  Previous read of size 4 at 0x7f406e9c31d4 by main thread:
    #0 reap_threads backend.c:1891 (fio+0x000000521b6f)
    #1 run_threads backend.c:2351 (fio+0x00000051b9ed)
    #2 fio_backend backend.c:2401 (fio+0x00000051b9ed)
    #3 main fio.c:65 (fio+0x000000424520)

  As if synchronized via sleep:
    #0 nanosleep
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:364
(fio+0x00000043106a)
    #1 usec_sleep time.c:58 (fio+0x0000004dd498)
    #2 read_iolog_get iolog.c:170 (fio+0x000000514e67)
    #3 get_io_u io_u.c:1623 (fio+0x0000004f1df4)
    #4 do_io backend.c:914 (fio+0x000000520319)
    #5 thread_main backend.c:1700 (fio+0x000000520319)

  Thread T2 (tid=54800, running) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race libfio.c:217 in td_set_runstate
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Write of size 8 at 0x7f406e9c3418 by thread T2:
    #0 free_ioengine ioengines.c:176 (fio+0x0000004c4be9)
    #1 close_ioengine ioengines.c:188 (fio+0x0000004c4be9)
    #2 thread_main backend.c:1813 (fio+0x00000051cda5)

  Previous read of size 8 at 0x7f406e9c3418 by main thread:
    #0 reap_threads backend.c:1882 (fio+0x000000521b0b)
    #1 run_threads backend.c:2344 (fio+0x00000051b8ba)
    #2 fio_backend backend.c:2401 (fio+0x00000051b8ba)
    #3 main fio.c:65 (fio+0x000000424520)

  As if synchronized via sleep:
    #0 nanosleep
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:364
(fio+0x00000043106a)
    #1 usec_sleep time.c:58 (fio+0x0000004dd498)
    #2 read_iolog_get iolog.c:170 (fio+0x000000514e67)
    #3 get_io_u io_u.c:1623 (fio+0x0000004f1df4)
    #4 do_io backend.c:914 (fio+0x000000520319)
    #5 thread_main backend.c:1700 (fio+0x000000520319)

  Thread T2 (tid=54800, running) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race ioengines.c:176 in free_ioengine
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Write of size 8 at 0x7f40875dd028 by thread T2:
    #0 pthread_cond_destroy
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:1107
(fio+0x00000044c54c)
    #1 __fio_mutex_remove mutex.c:24 (fio+0x0000004f9518)
    #2 fio_mutex_remove mutex.c:35 (fio+0x0000004f9518)
    #3 thread_main backend.c:1838 (fio+0x00000051ce8a)

  Previous read of size 8 at 0x7f40875dd028 by main thread:
    #0 pthread_cond_signal
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:1093
(fio+0x00000044abee)
    #1 fio_mutex_up mutex.c:241 (fio+0x0000004f9c1b)
    #2 run_threads backend.c:2341 (fio+0x00000051b882)
    #3 fio_backend backend.c:2401 (fio+0x00000051b882)
    #4 main fio.c:65 (fio+0x000000424520)

  As if synchronized via sleep:
    #0 nanosleep
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:364
(fio+0x00000043106a)
    #1 usec_sleep time.c:58 (fio+0x0000004dd498)
    #2 read_iolog_get iolog.c:170 (fio+0x000000514e67)
    #3 get_io_u io_u.c:1623 (fio+0x0000004f1df4)
    #4 do_io backend.c:914 (fio+0x000000520319)
    #5 thread_main backend.c:1700 (fio+0x000000520319)

  Thread T2 (tid=54800, running) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race mutex.c:24 in __fio_mutex_remove
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 4 at 0x7f406e9c31a8 by main thread:
    #0 reap_threads backend.c:1962 (fio+0x000000521d94)
    #1 run_threads backend.c:2351 (fio+0x00000051b9ed)
    #2 fio_backend backend.c:2401 (fio+0x00000051b9ed)
    #3 main fio.c:65 (fio+0x000000424520)

  Previous write of size 4 at 0x7f406e9c31a8 by thread T2:
    [failed to restore the stack]

  As if synchronized via sleep:
    #0 usleep clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:357
(fio+0x000000430f07)
    #1 do_usleep backend.c:2047 (fio+0x00000051ba01)
    #2 run_threads backend.c:2352 (fio+0x00000051ba01)
    #3 fio_backend backend.c:2401 (fio+0x00000051ba01)
    #4 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, finished) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race backend.c:1962 in reap_threads
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 8 at 0x7f406e9c2e38 by thread T1:
    #0 finalize_logs stat.c:2167 (fio+0x0000004d7632)
    #1 td_writeout_logs iolog.c:1555 (fio+0x000000519381)
    #2 fio_writeout_logs iolog.c:1586 (fio+0x000000519381)
    #3 helper_thread_main helper_thread.c:131 (fio+0x00000052ebb4)

  Previous write of size 8 at 0x7f406e9c2e38 by thread T2:
    #0 write_clat_log iolog.c:1457 (fio+0x000000519d2f)
    #1 td_writeout_logs iolog.c:1565 (fio+0x0000005192ac)
    #2 thread_main backend.c:1792 (fio+0x00000051e575)

  Thread T1 (tid=54799, running) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 helper_thread_create helper_thread.c:154 (fio+0x00000052e90f)
    #2 fio_backend backend.c:2396 (fio+0x00000051ab8d)
    #3 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, finished) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race stat.c:2167 in finalize_logs
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 8 at 0x7f406e9c2e30 by thread T1:
    #0 finalize_logs stat.c:2169 (fio+0x0000004d7679)
    #1 td_writeout_logs iolog.c:1555 (fio+0x000000519381)
    #2 fio_writeout_logs iolog.c:1586 (fio+0x000000519381)
    #3 helper_thread_main helper_thread.c:131 (fio+0x00000052ebb4)

  Previous write of size 8 at 0x7f406e9c2e30 by thread T2:
    #0 write_slat_log iolog.c:1443 (fio+0x000000519cbf)
    #1 td_writeout_logs iolog.c:1565 (fio+0x0000005192ac)
    #2 thread_main backend.c:1792 (fio+0x00000051e575)

  Thread T1 (tid=54799, running) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 helper_thread_create helper_thread.c:154 (fio+0x00000052e90f)
    #2 fio_backend backend.c:2396 (fio+0x00000051ab8d)
    #3 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, finished) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race stat.c:2169 in finalize_logs
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 8 at 0x7f406e9c2e48 by thread T1:
    #0 finalize_logs stat.c:2171 (fio+0x0000004d76ba)
    #1 td_writeout_logs iolog.c:1555 (fio+0x000000519381)
    #2 fio_writeout_logs iolog.c:1586 (fio+0x000000519381)
    #3 helper_thread_main helper_thread.c:131 (fio+0x00000052ebb4)

  Previous write of size 8 at 0x7f406e9c2e48 by thread T2:
    #0 write_lat_log iolog.c:1485 (fio+0x000000519c4f)
    #1 td_writeout_logs iolog.c:1565 (fio+0x0000005192ac)
    #2 thread_main backend.c:1792 (fio+0x00000051e575)

  Thread T1 (tid=54799, running) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 helper_thread_create helper_thread.c:154 (fio+0x00000052e90f)
    #2 fio_backend backend.c:2396 (fio+0x00000051ab8d)
    #3 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, finished) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race stat.c:2171 in finalize_logs
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Write of size 8 at 0x7f406e9c2e50 by thread T1:
    #0 write_bandw_log iolog.c:1499 (fio+0x000000519bdb)
    #1 td_writeout_logs iolog.c:1565 (fio+0x0000005193bb)
    #2 fio_writeout_logs iolog.c:1586 (fio+0x0000005193bb)
    #3 helper_thread_main helper_thread.c:131 (fio+0x00000052ebb4)

  Previous read of size 8 at 0x7f406e9c2e50 by thread T2:
    #0 finalize_logs stat.c:2174 (fio+0x0000004d76fb)
    #1 td_writeout_logs iolog.c:1555 (fio+0x000000519271)
    #2 thread_main backend.c:1792 (fio+0x00000051e575)

  Thread T1 (tid=54799, running) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 helper_thread_create helper_thread.c:154 (fio+0x00000052e90f)
    #2 fio_backend backend.c:2396 (fio+0x00000051ab8d)
    #3 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, finished) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race iolog.c:1499 in write_bandw_log
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Write of size 8 at 0x7f406e9c2e58 by thread T1:
    #0 write_iops_log iolog.c:1429 (fio+0x000000519dcb)
    #1 td_writeout_logs iolog.c:1565 (fio+0x0000005193bb)
    #2 fio_writeout_logs iolog.c:1586 (fio+0x0000005193bb)
    #3 helper_thread_main helper_thread.c:131 (fio+0x00000052ebb4)

  Previous read of size 8 at 0x7f406e9c2e58 by thread T2:
    #0 finalize_logs stat.c:2176 (fio+0x0000004d7752)
    #1 td_writeout_logs iolog.c:1555 (fio+0x000000519271)
    #2 thread_main backend.c:1792 (fio+0x00000051e575)

  Thread T1 (tid=54799, running) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 helper_thread_create helper_thread.c:154 (fio+0x00000052e90f)
    #2 fio_backend backend.c:2396 (fio+0x00000051ab8d)
    #3 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, finished) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race iolog.c:1429 in write_iops_log
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 4 at 0x7f406e9c3888 by main thread:
    #0 __show_run_stats stat.c:1573 (fio+0x0000004d5d50)
    #1 fio_backend backend.c:2406 (fio+0x00000051ba4d)
    #2 main fio.c:65 (fio+0x000000424520)

  Previous write of size 4 at 0x7f406e9c3888 by thread T2:
    [failed to restore the stack]

  As if synchronized via sleep:
    #0 usleep clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:357
(fio+0x000000430f07)
    #1 do_usleep backend.c:2047 (fio+0x00000051ba01)
    #2 run_threads backend.c:2352 (fio+0x00000051ba01)
    #3 fio_backend backend.c:2401 (fio+0x00000051ba01)
    #4 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, finished) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race stat.c:1573 in __show_run_stats
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 8 at 0x7f406e9b6ef4 by main thread:
    #0 sum_stat stat.c:1322 (fio+0x0000004d2b74)
    #1 sum_thread_stats stat.c:1358 (fio+0x0000004d2b74)
    #2 __show_run_stats stat.c:1582 (fio+0x0000004d5e76)
    #3 fio_backend backend.c:2406 (fio+0x00000051ba4d)
    #4 main fio.c:65 (fio+0x000000424520)

  Previous write of size 8 at 0x7f406e9b6ef4 by thread T2:
    [failed to restore the stack]

  As if synchronized via sleep:
    #0 usleep clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:357
(fio+0x000000430f07)
    #1 do_usleep backend.c:2047 (fio+0x00000051ba01)
    #2 run_threads backend.c:2352 (fio+0x00000051ba01)
    #3 fio_backend backend.c:2401 (fio+0x00000051ba01)
    #4 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, finished) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race stat.c:1322 in sum_stat
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 8 at 0x7f406e9b6eec by main thread:
    #0 sum_stat stat.c:1299 (fio+0x0000004d2cb6)
    #1 sum_thread_stats stat.c:1358 (fio+0x0000004d2cb6)
    #2 __show_run_stats stat.c:1582 (fio+0x0000004d5e76)
    #3 fio_backend backend.c:2406 (fio+0x00000051ba4d)
    #4 main fio.c:65 (fio+0x000000424520)

  Previous write of size 8 at 0x7f406e9b6eec by thread T2:
    [failed to restore the stack]

  As if synchronized via sleep:
    #0 usleep clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:357
(fio+0x000000430f07)
    #1 do_usleep backend.c:2047 (fio+0x00000051ba01)
    #2 run_threads backend.c:2352 (fio+0x00000051ba01)
    #3 fio_backend backend.c:2401 (fio+0x00000051ba01)
    #4 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, finished) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race stat.c:1299 in sum_stat
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 8 at 0x7f406e9b6ee4 by main thread:
    #0 sum_stat stat.c:1300 (fio+0x0000004d2cfa)
    #1 sum_thread_stats stat.c:1358 (fio+0x0000004d2cfa)
    #2 __show_run_stats stat.c:1582 (fio+0x0000004d5e76)
    #3 fio_backend backend.c:2406 (fio+0x00000051ba4d)
    #4 main fio.c:65 (fio+0x000000424520)

  Previous write of size 8 at 0x7f406e9b6ee4 by thread T2:
    [failed to restore the stack]

  As if synchronized via sleep:
    #0 usleep clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:357
(fio+0x000000430f07)
    #1 do_usleep backend.c:2047 (fio+0x00000051ba01)
    #2 run_threads backend.c:2352 (fio+0x00000051ba01)
    #3 fio_backend backend.c:2401 (fio+0x00000051ba01)
    #4 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, finished) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race stat.c:1300 in sum_stat
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 8 at 0x7f406e9b6efc by main thread:
    #0 sum_stat stat.c:1308 (fio+0x0000004d2d26)
    #1 sum_thread_stats stat.c:1358 (fio+0x0000004d2d26)
    #2 __show_run_stats stat.c:1582 (fio+0x0000004d5e76)
    #3 fio_backend backend.c:2406 (fio+0x00000051ba4d)
    #4 main fio.c:65 (fio+0x000000424520)

  Previous write of size 8 at 0x7f406e9b6efc by thread T2:
    [failed to restore the stack]

  As if synchronized via sleep:
    #0 usleep clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:357
(fio+0x000000430f07)
    #1 do_usleep backend.c:2047 (fio+0x00000051ba01)
    #2 run_threads backend.c:2352 (fio+0x00000051ba01)
    #3 fio_backend backend.c:2401 (fio+0x00000051ba01)
    #4 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, finished) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race stat.c:1308 in sum_stat
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 8 at 0x7f406e9b6f0c by main thread:
    #0 sum_stat stat.c:1309 (fio+0x0000004d2d4d)
    #1 sum_thread_stats stat.c:1358 (fio+0x0000004d2d4d)
    #2 __show_run_stats stat.c:1582 (fio+0x0000004d5e76)
    #3 fio_backend backend.c:2406 (fio+0x00000051ba4d)
    #4 main fio.c:65 (fio+0x000000424520)

  Previous write of size 8 at 0x7f406e9b6f0c by thread T2:
    [failed to restore the stack]

  As if synchronized via sleep:
    #0 usleep clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:357
(fio+0x000000430f07)
    #1 do_usleep backend.c:2047 (fio+0x00000051ba01)
    #2 run_threads backend.c:2352 (fio+0x00000051ba01)
    #3 fio_backend backend.c:2401 (fio+0x00000051ba01)
    #4 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, finished) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race stat.c:1309 in sum_stat
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 8 at 0x7f406e9b7044 by main thread:
    #0 sum_stat stat.c:1322 (fio+0x0000004d3c17)
    #1 sum_thread_stats stat.c:1360 (fio+0x0000004d3c17)
    #2 __show_run_stats stat.c:1582 (fio+0x0000004d5e76)
    #3 fio_backend backend.c:2406 (fio+0x00000051ba4d)
    #4 main fio.c:65 (fio+0x000000424520)

  Previous write of size 8 at 0x7f406e9b7044 by thread T2:
    [failed to restore the stack]

  As if synchronized via sleep:
    #0 usleep clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:357
(fio+0x000000430f07)
    #1 do_usleep backend.c:2047 (fio+0x00000051ba01)
    #2 run_threads backend.c:2352 (fio+0x00000051ba01)
    #3 fio_backend backend.c:2401 (fio+0x00000051ba01)
    #4 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, finished) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race stat.c:1322 in sum_stat
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 8 at 0x7f406e9b703c by main thread:
    #0 sum_stat stat.c:1299 (fio+0x0000004d3c52)
    #1 sum_thread_stats stat.c:1360 (fio+0x0000004d3c52)
    #2 __show_run_stats stat.c:1582 (fio+0x0000004d5e76)
    #3 fio_backend backend.c:2406 (fio+0x00000051ba4d)
    #4 main fio.c:65 (fio+0x000000424520)

  Previous write of size 8 at 0x7f406e9b703c by thread T2:
    [failed to restore the stack]

  As if synchronized via sleep:
    #0 usleep clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:357
(fio+0x000000430f07)
    #1 do_usleep backend.c:2047 (fio+0x00000051ba01)
    #2 run_threads backend.c:2352 (fio+0x00000051ba01)
    #3 fio_backend backend.c:2401 (fio+0x00000051ba01)
    #4 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, finished) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race stat.c:1299 in sum_stat
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 8 at 0x7f406e9b7034 by main thread:
    #0 sum_stat stat.c:1300 (fio+0x0000004d3c96)
    #1 sum_thread_stats stat.c:1360 (fio+0x0000004d3c96)
    #2 __show_run_stats stat.c:1582 (fio+0x0000004d5e76)
    #3 fio_backend backend.c:2406 (fio+0x00000051ba4d)
    #4 main fio.c:65 (fio+0x000000424520)

  Previous write of size 8 at 0x7f406e9b7034 by thread T2:
    [failed to restore the stack]

  As if synchronized via sleep:
    #0 usleep clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:357
(fio+0x000000430f07)
    #1 do_usleep backend.c:2047 (fio+0x00000051ba01)
    #2 run_threads backend.c:2352 (fio+0x00000051ba01)
    #3 fio_backend backend.c:2401 (fio+0x00000051ba01)
    #4 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, finished) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race stat.c:1300 in sum_stat
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 8 at 0x7f406e9b704c by main thread:
    #0 sum_stat stat.c:1308 (fio+0x0000004d3cc2)
    #1 sum_thread_stats stat.c:1360 (fio+0x0000004d3cc2)
    #2 __show_run_stats stat.c:1582 (fio+0x0000004d5e76)
    #3 fio_backend backend.c:2406 (fio+0x00000051ba4d)
    #4 main fio.c:65 (fio+0x000000424520)

  Previous write of size 8 at 0x7f406e9b704c by thread T2:
    [failed to restore the stack]

  As if synchronized via sleep:
    #0 usleep clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:357
(fio+0x000000430f07)
    #1 do_usleep backend.c:2047 (fio+0x00000051ba01)
    #2 run_threads backend.c:2352 (fio+0x00000051ba01)
    #3 fio_backend backend.c:2401 (fio+0x00000051ba01)
    #4 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, finished) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race stat.c:1308 in sum_stat
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 8 at 0x7f406e9b705c by main thread:
    #0 sum_stat stat.c:1309 (fio+0x0000004d3ce5)
    #1 sum_thread_stats stat.c:1360 (fio+0x0000004d3ce5)
    #2 __show_run_stats stat.c:1582 (fio+0x0000004d5e76)
    #3 fio_backend backend.c:2406 (fio+0x00000051ba4d)
    #4 main fio.c:65 (fio+0x000000424520)

  Previous write of size 8 at 0x7f406e9b705c by thread T2:
    [failed to restore the stack]

  As if synchronized via sleep:
    #0 usleep clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:357
(fio+0x000000430f07)
    #1 do_usleep backend.c:2047 (fio+0x00000051ba01)
    #2 run_threads backend.c:2352 (fio+0x00000051ba01)
    #3 fio_backend backend.c:2401 (fio+0x00000051ba01)
    #4 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, finished) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race stat.c:1309 in sum_stat
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 4 at 0x7f406e9badac by main thread:
    #0 sum_thread_stats stat.c:1363 (fio+0x0000004d420d)
    #1 __show_run_stats stat.c:1582 (fio+0x0000004d5e76)
    #2 fio_backend backend.c:2406 (fio+0x00000051ba4d)
    #3 main fio.c:65 (fio+0x000000424520)

  Previous write of size 4 at 0x7f406e9badac by thread T2:
    #0 thread_main backend.c:1782 (fio+0x00000051e498)

  As if synchronized via sleep:
    #0 usleep clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:357
(fio+0x000000430f07)
    #1 do_usleep backend.c:2047 (fio+0x00000051ba01)
    #2 run_threads backend.c:2352 (fio+0x00000051ba01)
    #3 fio_backend backend.c:2401 (fio+0x00000051ba01)
    #4 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, finished) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race stat.c:1363 in sum_thread_stats
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 4 at 0x7f406e9badc4 by main thread:
    #0 sum_thread_stats stat.c:1365 (fio+0x0000004d4263)
    #1 __show_run_stats stat.c:1582 (fio+0x0000004d5e76)
    #2 fio_backend backend.c:2406 (fio+0x00000051ba4d)
    #3 main fio.c:65 (fio+0x000000424520)

  Previous write of size 4 at 0x7f406e9badc4 by thread T2:
    #0 update_runtime backend.c:378 (fio+0x00000051ec73)
    #1 thread_main backend.c:1742 (fio+0x00000051ec73)

  As if synchronized via sleep:
    #0 usleep clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:357
(fio+0x000000430f07)
    #1 do_usleep backend.c:2047 (fio+0x00000051ba01)
    #2 run_threads backend.c:2352 (fio+0x00000051ba01)
    #3 fio_backend backend.c:2401 (fio+0x00000051ba01)
    #4 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, finished) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race stat.c:1365 in sum_thread_stats
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 4 at 0x7f406e9badb4 by main thread:
    #0 sum_thread_stats stat.c:1363 (fio+0x0000004d420d)
    #1 __show_run_stats stat.c:1582 (fio+0x0000004d5e76)
    #2 fio_backend backend.c:2406 (fio+0x00000051ba4d)
    #3 main fio.c:65 (fio+0x000000424520)

  Previous write of size 4 at 0x7f406e9badb4 by thread T2:
    #0 thread_main backend.c:1783 (fio+0x00000051e4be)

  As if synchronized via sleep:
    #0 usleep clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:357
(fio+0x000000430f07)
    #1 do_usleep backend.c:2047 (fio+0x00000051ba01)
    #2 run_threads backend.c:2352 (fio+0x00000051ba01)
    #3 fio_backend backend.c:2401 (fio+0x00000051ba01)
    #4 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, finished) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race stat.c:1363 in sum_thread_stats
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 4 at 0x7f406e9badbc by main thread:
    #0 sum_thread_stats stat.c:1363 (fio+0x0000004d420d)
    #1 __show_run_stats stat.c:1582 (fio+0x0000004d5e76)
    #2 fio_backend backend.c:2406 (fio+0x00000051ba4d)
    #3 main fio.c:65 (fio+0x000000424520)

  Previous write of size 4 at 0x7f406e9badbc by thread T2:
    #0 thread_main backend.c:1784 (fio+0x00000051e4e4)

  As if synchronized via sleep:
    #0 usleep clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:357
(fio+0x000000430f07)
    #1 do_usleep backend.c:2047 (fio+0x00000051ba01)
    #2 run_threads backend.c:2352 (fio+0x00000051ba01)
    #3 fio_backend backend.c:2401 (fio+0x00000051ba01)
    #4 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, finished) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race stat.c:1363 in sum_thread_stats
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 4 at 0x7f406e9b722c by main thread:
    #0 sum_thread_stats stat.c:1386 (fio+0x0000004d42d0)
    #1 __show_run_stats stat.c:1582 (fio+0x0000004d5e76)
    #2 fio_backend backend.c:2406 (fio+0x00000051ba4d)
    #3 main fio.c:65 (fio+0x000000424520)

  Previous write of size 4 at 0x7f406e9b722c by thread T2:
    #0 update_rusage_stat stat.c:40 (fio+0x0000004ce461)
    #1 thread_main backend.c:1780 (fio+0x00000051e456)

  As if synchronized via sleep:
    #0 usleep clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:357
(fio+0x000000430f07)
    #1 do_usleep backend.c:2047 (fio+0x00000051ba01)
    #2 run_threads backend.c:2352 (fio+0x00000051ba01)
    #3 fio_backend backend.c:2401 (fio+0x00000051ba01)
    #4 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, finished) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race stat.c:1386 in sum_thread_stats
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 4 at 0x7f406e9b7238 by main thread:
    #0 sum_thread_stats stat.c:1386 (fio+0x0000004d42d0)
    #1 __show_run_stats stat.c:1582 (fio+0x0000004d5e76)
    #2 fio_backend backend.c:2406 (fio+0x00000051ba4d)
    #3 main fio.c:65 (fio+0x000000424520)

  Previous write of size 8 at 0x7f406e9b7238 by thread T2:
    #0 update_rusage_stat stat.c:42 (fio+0x0000004ce500)
    #1 thread_main backend.c:1780 (fio+0x00000051e456)

  As if synchronized via sleep:
    #0 usleep clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:357
(fio+0x000000430f07)
    #1 do_usleep backend.c:2047 (fio+0x00000051ba01)
    #2 run_threads backend.c:2352 (fio+0x00000051ba01)
    #3 fio_backend backend.c:2401 (fio+0x00000051ba01)
    #4 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, finished) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race stat.c:1386 in sum_thread_stats
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 4 at 0x7f406e9b724c by main thread:
    #0 sum_thread_stats stat.c:1389 (fio+0x0000004d4325)
    #1 __show_run_stats stat.c:1582 (fio+0x0000004d5e76)
    #2 fio_backend backend.c:2406 (fio+0x00000051ba4d)
    #3 main fio.c:65 (fio+0x000000424520)

  Previous write of size 8 at 0x7f406e9b7248 by thread T2:
    #0 update_rusage_stat stat.c:46 (fio+0x0000004ce570)
    #1 thread_main backend.c:1780 (fio+0x00000051e456)

  As if synchronized via sleep:
    #0 usleep clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:357
(fio+0x000000430f07)
    #1 do_usleep backend.c:2047 (fio+0x00000051ba01)
    #2 run_threads backend.c:2352 (fio+0x00000051ba01)
    #3 fio_backend backend.c:2401 (fio+0x00000051ba01)
    #4 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, finished) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race stat.c:1389 in sum_thread_stats
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 4 at 0x7f406e9b73a4 by main thread:
    #0 sum_thread_stats stat.c:1393 (fio+0x0000004d4395)
    #1 __show_run_stats stat.c:1582 (fio+0x0000004d5e76)
    #2 fio_backend backend.c:2406 (fio+0x00000051ba4d)
    #3 main fio.c:65 (fio+0x000000424520)

  Previous write of size 4 at 0x7f406e9b73a4 by thread T2:
    [failed to restore the stack]

  As if synchronized via sleep:
    #0 usleep clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:357
(fio+0x000000430f07)
    #1 do_usleep backend.c:2047 (fio+0x00000051ba01)
    #2 run_threads backend.c:2352 (fio+0x00000051ba01)
    #3 fio_backend backend.c:2401 (fio+0x00000051ba01)
    #4 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, finished) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race stat.c:1393 in sum_thread_stats
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 4 at 0x7f406e9b7400 by main thread:
    #0 sum_thread_stats stat.c:1399 (fio+0x0000004d47a0)
    #1 __show_run_stats stat.c:1582 (fio+0x0000004d5e76)
    #2 fio_backend backend.c:2406 (fio+0x00000051ba4d)
    #3 main fio.c:65 (fio+0x000000424520)

  Previous write of size 4 at 0x7f406e9b7400 by thread T2:
    [failed to restore the stack]

  As if synchronized via sleep:
    #0 usleep clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:357
(fio+0x000000430f07)
    #1 do_usleep backend.c:2047 (fio+0x00000051ba01)
    #2 run_threads backend.c:2352 (fio+0x00000051ba01)
    #3 fio_backend backend.c:2401 (fio+0x00000051ba01)
    #4 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, finished) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race stat.c:1399 in sum_thread_stats
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 4 at 0x7f406e9b7404 by main thread:
    #0 sum_thread_stats stat.c:1399 (fio+0x0000004d47cd)
    #1 __show_run_stats stat.c:1582 (fio+0x0000004d5e76)
    #2 fio_backend backend.c:2406 (fio+0x00000051ba4d)
    #3 main fio.c:65 (fio+0x000000424520)

  Previous write of size 4 at 0x7f406e9b7404 by thread T2:
    [failed to restore the stack]

  As if synchronized via sleep:
    #0 usleep clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:357
(fio+0x000000430f07)
    #1 do_usleep backend.c:2047 (fio+0x00000051ba01)
    #2 run_threads backend.c:2352 (fio+0x00000051ba01)
    #3 fio_backend backend.c:2401 (fio+0x00000051ba01)
    #4 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, finished) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race stat.c:1399 in sum_thread_stats
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 4 at 0x7f406e9bad54 by main thread:
    #0 sum_thread_stats stat.c:1409 (fio+0x0000004d4b58)
    #1 __show_run_stats stat.c:1582 (fio+0x0000004d5e76)
    #2 fio_backend backend.c:2406 (fio+0x00000051ba4d)
    #3 main fio.c:65 (fio+0x000000424520)

  Previous write of size 4 at 0x7f406e9bad54 by thread T2:
    [failed to restore the stack]

  As if synchronized via sleep:
    #0 usleep clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:357
(fio+0x000000430f07)
    #1 do_usleep backend.c:2047 (fio+0x00000051ba01)
    #2 run_threads backend.c:2352 (fio+0x00000051ba01)
    #3 fio_backend backend.c:2401 (fio+0x00000051ba01)
    #4 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, finished) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race stat.c:1409 in sum_thread_stats
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 8 at 0x7f406e9b7470 by main thread:
    #0 sum_thread_stats stat.c:1422 (fio+0x0000004d4fa6)
    #1 __show_run_stats stat.c:1582 (fio+0x0000004d5e76)
    #2 fio_backend backend.c:2406 (fio+0x00000051ba4d)
    #3 main fio.c:65 (fio+0x000000424520)

  Previous write of size 4 at 0x7f406e9b7474 by thread T2:
    [failed to restore the stack]

  As if synchronized via sleep:
    #0 usleep clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:357
(fio+0x000000430f07)
    #1 do_usleep backend.c:2047 (fio+0x00000051ba01)
    #2 run_threads backend.c:2352 (fio+0x00000051ba01)
    #3 fio_backend backend.c:2401 (fio+0x00000051ba01)
    #4 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, finished) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race stat.c:1422 in sum_thread_stats
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 8 at 0x7f406e9b7498 by main thread:
    #0 sum_thread_stats stat.c:1422 (fio+0x0000004d4eec)
    #1 __show_run_stats stat.c:1582 (fio+0x0000004d5e76)
    #2 fio_backend backend.c:2406 (fio+0x00000051ba4d)
    #3 main fio.c:65 (fio+0x000000424520)

  Previous write of size 4 at 0x7f406e9b749c by thread T2:
    [failed to restore the stack]

  As if synchronized via sleep:
    #0 usleep clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:357
(fio+0x000000430f07)
    #1 do_usleep backend.c:2047 (fio+0x00000051ba01)
    #2 run_threads backend.c:2352 (fio+0x00000051ba01)
    #3 fio_backend backend.c:2401 (fio+0x00000051ba01)
    #4 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, finished) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race stat.c:1422 in sum_thread_stats
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 4 at 0x7f406e9baddc by main thread:
    #0 sum_thread_stats stat.c:1426 (fio+0x0000004d5259)
    #1 __show_run_stats stat.c:1582 (fio+0x0000004d5e76)
    #2 fio_backend backend.c:2406 (fio+0x00000051ba4d)
    #3 main fio.c:65 (fio+0x000000424520)

  Previous write of size 4 at 0x7f406e9baddc by thread T2:
    #0 thread_main backend.c:1781 (fio+0x00000051e472)

  As if synchronized via sleep:
    #0 usleep clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:357
(fio+0x000000430f07)
    #1 do_usleep backend.c:2047 (fio+0x00000051ba01)
    #2 run_threads backend.c:2352 (fio+0x00000051ba01)
    #3 fio_backend backend.c:2401 (fio+0x00000051ba01)
    #4 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, finished) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race stat.c:1426 in sum_thread_stats
==================

replay: (groupid=0, jobs=1): err= 0: pid=54800: Thu Dec 15 07:00:29 2016
  read : io=1536B, bw=212B/s, iops=0, runt=  7242msec
    clat (usec): min=9, max=19, avg=12.67, stdev= 5.51
     lat (usec): min=12, max=23, avg=16.33, stdev= 5.86
    clat percentiles (usec):
     |  1.00th=[    9],  5.00th=[    9], 10.00th=[    9], 20.00th=[    9],
     | 30.00th=[    9], 40.00th=[   10], 50.00th=[   10], 60.00th=[   10],
     | 70.00th=[   19], 80.00th=[   19], 90.00th=[   19], 95.00th=[   19],
     | 99.00th=[   19], 99.50th=[   19], 99.90th=[   19], 99.95th=[   19],
     | 99.99th=[   19]
    lat (usec) : 10=33.33%, 20=66.67%
  cpu          : usr=0.28%, sys=0.22%, ctx=30, majf=8, minf=325
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=3/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   READ: io=1KB, aggrb=0KB/s, minb=0KB/s, maxb=0KB/s, mint=7242msec,
maxt=7242msec
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Read of size 8 at 0x7f406e9b6080 by main thread:
    #0 options_free parse.c:1316 (fio+0x0000004f908d)
    #1 fio_options_free options.c:4750 (fio+0x0000004fe3df)
    #2 fio_backend backend.c:2418 (fio+0x00000051bb0b)
    #3 main fio.c:65 (fio+0x000000424520)

  Previous write of size 8 at 0x7f406e9b6080 by thread T2:
    #0 close_and_free_files filesetup.c:1209 (fio+0x0000004e22f6)
    #1 thread_main backend.c:1811 (fio+0x00000051cbf6)

  As if synchronized via sleep:
    #0 usleep clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:357
(fio+0x000000430f07)
    #1 do_usleep backend.c:2047 (fio+0x00000051ba01)
    #2 run_threads backend.c:2352 (fio+0x00000051ba01)
    #3 fio_backend backend.c:2401 (fio+0x00000051ba01)
    #4 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, finished) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race parse.c:1316 in options_free
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Write of size 8 at 0x7d040000f720 by main thread:
    #0 free clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:634
(fio+0x00000042c5fe)
    #1 options_free parse.c:1317 (fio+0x0000004f909c)
    #2 fio_options_free options.c:4750 (fio+0x0000004fe3df)
    #3 fio_backend backend.c:2418 (fio+0x00000051bb0b)
    #4 main fio.c:65 (fio+0x000000424520)

  Previous read of size 8 at 0x7d040000f720 by thread T2:
    [failed to restore the stack]

  As if synchronized via sleep:
    #0 usleep clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:357
(fio+0x000000430f07)
    #1 do_usleep backend.c:2047 (fio+0x00000051ba01)
    #2 run_threads backend.c:2352 (fio+0x00000051ba01)
    #3 fio_backend backend.c:2401 (fio+0x00000051ba01)
    #4 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, finished) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race parse.c:1317 in options_free
==================
==================
WARNING: ThreadSanitizer: data race (pid=54796)
  Write of size 8 at 0x7f406e9b6b68 by main thread:
    #0 options_free parse.c:1318 (fio+0x0000004f90a4)
    #1 fio_options_free options.c:4750 (fio+0x0000004fe3df)
    #2 fio_backend backend.c:2418 (fio+0x00000051bb0b)
    #3 main fio.c:65 (fio+0x000000424520)

  Previous read of size 8 at 0x7f406e9b6b68 by thread T2:
    [failed to restore the stack]

  As if synchronized via sleep:
    #0 usleep clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:357
(fio+0x000000430f07)
    #1 do_usleep backend.c:2047 (fio+0x00000051ba01)
    #2 run_threads backend.c:2352 (fio+0x00000051ba01)
    #3 fio_backend backend.c:2401 (fio+0x00000051ba01)
    #4 main fio.c:65 (fio+0x000000424520)

  Thread T2 (tid=54800, finished) created by main thread at:
    #0 pthread_create
clang-3.9/llvm/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors.cc:902
(fio+0x00000042c6f6)
    #1 run_threads backend.c:2249 (fio+0x00000051b47f)
    #2 fio_backend backend.c:2401 (fio+0x00000051b47f)
    #3 main fio.c:65 (fio+0x000000424520)

SUMMARY: ThreadSanitizer: data race parse.c:1318 in options_free
==================
ThreadSanitizer: reported 50 warnings


-- 
Sitsofe | http://sucs.org/~sits/

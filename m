Return-Path: <fio-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:10598 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbgCRBSt (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 17 Mar 2020 21:18:49 -0400
Date: Tue, 17 Mar 2020 11:50:07 +0900
From: Naohiro Aota <naohiro.aota@wdc.com>
Subject: Re: [PATCH 0/6] Fix zone lock deadlock
Message-ID: <20200317025007.4zjark6b5ywea4v7@naota.dhcp.fujisawa.hgst.com>
References: <20200228071248.3981623-1-naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200228071248.3981623-1-naohiro.aota@wdc.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org

On Fri, Feb 28, 2020 at 04:12:42PM +0900, Naohiro Aota wrote:
>With zonemode=zbd and asynchronous ioengine, a thread takes a zone lock
>before an I/O submission (in zbd_adjust_block() or
>zbd_convert_to_open_zone()) and releases the lock after the I/O is put (in
>zbd_put_io()).  With a small number of open zones and/or a large number of
>jobs, threads can easily end up circular lock dependency and deadlocks. For
>example, thread A sends an I/O to zone 0, so thread A holds a zone lock #0.
>Then, thread A continues on zone 1 and try to acquire zone lock #1. At the
>same time, thread B held zone lock #1, sent I/O to zone 1, and try to
>acquire zone #0. Now, both threads are waiting for each other's lock, which
>is never released.
>
>This series fixes three problems to eliminate the deadlock. First, taking
>all the zone locks should be avoided. zbd_process_swd() and
>zbd_reset_zones() take the lock for all zones of the specified device,
>preventing other threads from accessing different zones in parallel. While
>it is not the root cause of the deadlock, such all zone locking easily
>trigger a deadlock. So, this series reduces such contentions by (1)
>eliminating unnecessary invocation of zbd_process_swd() and (2) changing to
>take single zone at at time in zbd_reset_zones().
>
>Secondly, zbd's I/O issuing path should expect lock contention with other
>threads and handle the case properly. Commit 6f0c608564c3 ("zbd: Avoid
>async I/O multi-job workload deadlock") also addressed this issue by using
>pthread_mutex_try_lock() and io_u_quiesce(). However, there are more
>pthread_mutex_lock() left to be fixed in the same way.
>
>Finally, fio should clean up I/Os properly on an error case. Currently,
>cleanup_pending_aio() and io_u_quiesce() fail to clean up I/Os with an
>error. As a result, zone locks, which are held by an erroneous thread, are
>kept held and blocks other threads to acquire the locks.
>
>This series also add a test case to cause the deadlock with unpatched fio.
>
>Patches 1 and 2 avoid long range lock holding to reduce lock contentions.
>
>Patch 3 introduces zone_lock and use it to handle the lock contention case.
>
>Patches 4 and 5 fix error path to clean up all the pending I/Os left.
>
>Patch 6 adds the test.
>
>Naohiro Aota (6):
>  zbd: avoid initializing swd when unnecessary
>  zbd: reset one zone at a time
>  zbd: use zone_lock to lock a zone
>  backend: always clean up pending aios
>  io_u: ensure io_u_quiesce() to process all the IOs
>  zbd: add test for stressing zone locking
>
> backend.c              |  5 ---
> io_u.c                 |  6 +--
> t/zbd/test-zbd-support | 30 +++++++++++++++
> zbd.c                  | 84 ++++++++++++++++--------------------------
> 4 files changed, 65 insertions(+), 60 deletions(-)
>
>-- 
>2.25.1

Ping on this series (also on this
https://www.spinics.net/lists/fio/msg08322.html ).


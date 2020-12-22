Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.phas.ubc.ca ([142.103.236.13]:46384 "EHLO mail.phas.ubc.ca"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbgLVBcj (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 21 Dec 2020 20:32:39 -0500
Content-Type: text/plain; charset="utf-8"
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: Standard test parameters for NAS workloads?
From: Davor Cubranic <davor@phas.ubc.ca>
In-Reply-To: <CACnDUNrKDbee11b0xhSR1sYrkmetO3x0TpuesxrS-GHVe+kfoA@mail.gmail.com>
Date: Mon, 21 Dec 2020 17:31:56 -0800
Content-Transfer-Encoding: 8bit
Message-Id: <AC4BFD62-F645-4146-A1D3-30D783885B95@phas.ubc.ca>
References: <CACnDUNrKDbee11b0xhSR1sYrkmetO3x0TpuesxrS-GHVe+kfoA@mail.gmail.com>
List-Id: fio@vger.kernel.org
To: rickyp999@gmail.com
Cc: fio@vger.kernel.org

These are the fio settings used by StorageReview.com in their benchmarks: https://www.storagereview.com/fio-flexible-i-o-tester-synthetic-benchmark

Ars Technica’s series on RAID vs. ZFS (https://arstechnica.com/gadgets/2020/05/zfs-versus-raid-eight-ironwolf-disks-two-filesystems-one-winner) used this set of tests: https://github.com/jimsalterjrs/fio-test-scaffolding



> On Dec 21, 2020, at 2:49 PM, rickyp999@gmail.com wrote:
> 
> Hi,
> 
> I'm curious whether there are some standard or at least common test
> parameters for benchmarking NAS workloads.
> 
> If NAS is too specific, even a general one for HDD/SSD would be
> greatly appreciated.  My motivation is to use a common set of
> benchmarks to compare how options like RAID levels, network
> speed/protocol (through a NFS/SMB mount), and SSD cache affect
> performance.
> 
> Thank you,



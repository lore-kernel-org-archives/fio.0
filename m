Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55421 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755788AbdCLSvd (ORCPT
        <rfc822;fio@vger.kernel.org>); Sun, 12 Mar 2017 14:51:33 -0400
Subject: Re: [PATCH] Only enable arm64 CRC32 acceleration if the required
 header files are there
References: <20170312171612.32247-1-tytso@mit.edu>
From: Jens Axboe <axboe@fb.com>
Message-ID: <45312e9d-a04b-9b34-4144-132c8d91ca54@fb.com>
Date: Sun, 12 Mar 2017 12:50:56 -0600
MIME-Version: 1.0
In-Reply-To: <20170312171612.32247-1-tytso@mit.edu>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, fio@vger.kernel.org
Cc: wei.xiao@arm.com

On 03/12/2017 11:16 AM, Theodore Ts'o wrote:
> If the necessary header files are missing, then fio will bomb out when
> building on arm64.  So disable the hardware acceleration option in
> that case, since it's only performance improvement and not a
> functional regression to turn it off.

Thanks Ted, applied.

-- 
Jens Axboe


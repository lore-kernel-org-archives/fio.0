Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56281 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750714AbdALEEG (ORCPT
        <rfc822;fio@vger.kernel.org>); Wed, 11 Jan 2017 23:04:06 -0500
Date: Wed, 11 Jan 2017 21:04:02 -0700
From: Jens Axboe <axboe@fb.com>
Subject: Re: [PATCH] Support zlib in the Windows build (enables latency
 histogram logging)
Message-ID: <20170112040402.GD27546@kernel.dk>
References: <0416e3e3-c7da-637b-5c90-e0fc155e65cc@bluestop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0416e3e3-c7da-637b-5c90-e0fc155e65cc@bluestop.org>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Rebecca Cran <rebecca@bluestop.org>
Cc: fio@vger.kernel.org

On Mon, Jan 09 2017, Rebecca Cran wrote:
> Add support for building with zlib in the Windows build: this enables the
> latency histogram logging feature.

Thanks Rebecca, applied.

-- 
Jens Axboe


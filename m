Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3F91C4A10
	for <fio@vger.kernel.org>; Wed,  7 May 2025 07:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746604189; cv=none; b=IificB+uC1b/+r0GSt6HnwOvc/6OlfDVv5WVf5PImXfd4gdtrSNf8vF46YpAJdzRseF//TH08SoIXDcytx23xuSDrZPgHxInSQ8HkbtKz9p57iLWv1eXHKkNOckU2ZndoUNsateJy+d/VzrSMeeZdSdP8CxoNY8SaDcSzT+Bd/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746604189; c=relaxed/simple;
	bh=bI1C5BYxNv4BF9XFOE3DZ96WRhxfo4Egpc2d7ujUw0g=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=f8EjAeap6nsIRiddlOsD6Q1G2LjdRQrbAlOLk6gmh0tyZcqxFNJGja6wgv25xlwHzJ1z0Xu7bCkjUuaCkVSU+7BEodrqKADcAI62EN6Z1pQW1zETQEfsH6GhdbCD26w/s2zdqYRPqoxWFkMF8zldCVXMrTtno78L7fgQxJyvDXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n7fYp0Ll; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n7fYp0Ll"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C95C4CEF2;
	Wed,  7 May 2025 07:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746604188;
	bh=bI1C5BYxNv4BF9XFOE3DZ96WRhxfo4Egpc2d7ujUw0g=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=n7fYp0LlWxb2jgMv4EbNnYPGzdLR31L3lYWgiYEOtph+qouTKoLqProYcJ1QwGjlS
	 vYvBHJT2umUxNzvp9P3JWtp3WkLnIaqjLe5Alp9X5Pp0HCODu4Gfc4tq4KKxvxHUft
	 C/K1012bPZDbhSmdaWfIKPfeNJedrPV46yoBP4EjWJDWKbHP/jYTkBTCkiYPV3rz2p
	 Ytz9Y1zAE5IoQE6kLIN1Lffb7n5vna+Y0YSWtNmDcy5h2bkElMDqPNhajPC13cu07+
	 tRi60thb3yYg1pVHyIRf/cOQhKlHnhJM8n0SzYkSlUPQfWFbt8F6SHgwB3HZip3nDP
	 phb2VoRaLDd1A==
Message-ID: <cf114fe6-a699-4b5d-ab09-48a45083fbfc@kernel.org>
Date: Wed, 7 May 2025 16:48:38 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/8] zbd: add the recover_zbd_write_error option
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>
References: <20250425052148.126788-1-shinichiro.kawasaki@wdc.com>
 <20250425052148.126788-6-shinichiro.kawasaki@wdc.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250425052148.126788-6-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/25/25 2:21 PM, Shin'ichiro Kawasaki wrote:
> When the continue_on_error options is specified, it is expected that the
> workload continues to run when non-critical errors happen. However,
> write workloads with zonemode=zbd option can not continue after errors,
> if the failed writes cause partial data write on the target device. This
> partial write creates write pointer gap between the device and fio, then
> the next write requests by fio will fail due to unaligned write command
> errors. This restriction results in undesirable test stops during long
> runs for SMR drives which can recover defect sectors.
> 
> To allow the write workloads with zonemode=zbd to continue after write
> failures with partial data writes, introduce the new option
> recover_zbd_write_error. When this option is specified together with the
> continue_on_error option, fio checks the write pointer positions of the
> write target zones in the error handling step. Then fix the write
> pointer by moving it to the position that the failed writes would have
> moved. Bump up FIO_SERVER_VER to note that the new option is added.
> 
> For that purpose, add a new function zbd_recover_write_error(). Call it
> from zbd_queue_io() for sync IO engines, and from io_completed() for
> async IO engines. Modify zbd_queue_io() to pass the pointer to the
> status so that zbd_recover_write_error() can modify the status to ignore
> the errors. Add three fields to struct fio_zone_info. The two new fields
> writes_in_flight and max_write_error_offset track status of in-flight
> writes at the write error, so that the write pointer positions can be
> fixed after the in-flight writes completed. The field fixing_zone_wp
> stores that the write pointer fix is ongoing, then prohibit the new
> writes get issued to the zone.
> 
> When the failed write is synchronous, the write pointer fix is done by
> writing the left data for the failed write. This keeps the verify
> patterns written to the device, then verify works together with the
> continue_on_zbd_write_error option. When the failed write is
> asynchronous, other in-flight writes fail together. In this case, fio
> waits for all in-flight writes complete then fix the write pointer. Then
> verify data of the failed writes are lost and verify does not work.
> Check the continue_on_zbd_write_error option is not specified together
> with the verify workload and asynchronous IO engine.
> 
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research

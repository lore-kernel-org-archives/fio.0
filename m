Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA452DF68
	for <fio@vger.kernel.org>; Thu, 24 Apr 2025 14:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745506324; cv=none; b=P/nypOMxaX+B7PoGpuzoDEvm2hSkEkQGPds484nvymMaI6OZzRl6dES8oXzpYMxcaU05f8/TLu9kvv9udWmgBPw1PSwSbBprk4IPQbRhvJDI6QsNoYMaB21uTv9OlVkax++vmEvfe5pEc7KMm7UUyLEgQTmURhpU4Q2N5rk3NzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745506324; c=relaxed/simple;
	bh=UB9R1jRn9hiu1b34HVjLJemicx39J90scaQcsR0RAfk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gGue0rE+tEOpVbedmuoaY1LM8IGlLea1/wwNYpgMVghs4iJTxX6pjc3fgV4Adj8DUcYMuiZTL3HUx9W4V63KR0e/vKnX3tBpD2RGecLOpcKVLx0PKgTh1hiYdzGfvIoQgf9N/U6FWXO/VLKMWNwVXROaNxXnUKOw3QUt10Uq4N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GUTycaTK; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GUTycaTK"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-6e8ffa00555so10933156d6.0
        for <fio@vger.kernel.org>; Thu, 24 Apr 2025 07:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745506322; x=1746111122; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7SWBkpJWabjR2MtwjQzODwTA7jJkkH41SkvSCyp063A=;
        b=GUTycaTKsb3ZbAcb6G/+BkZ9FieJ9AQ9AXKE24wKoj3qKsq79jS3nUNxdbROUuL2+j
         l5TII29fol+OgPvW8OeyFjW7ngcPznrl9bDeQkFU2Xd1jU+dEBNQ551CwyzV0Cb1K4jp
         2O+br3SNbiMrmdJDweoUi7JSbVLV0cEs1Xj/J0YFuLduodU9K/wSRd5zfqYBNav0NuQQ
         qzcaw/o1cbGGaGSlZfh5PjI/TOhwpiZqLNwWE0ik+dNgJapnfIAPnoJ63qu7Se0mBMp9
         nMUomMf0mkOqeDgmldnyJM7+C9fIXIEp2GOzN8vvpfUW+FeYtsihXTiQunOzIGwXxhac
         3Bmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745506322; x=1746111122;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7SWBkpJWabjR2MtwjQzODwTA7jJkkH41SkvSCyp063A=;
        b=gQ9b6oTVCe/vXypNMfKvvDJscU7KBeqact6a4uCwzb6NazuNp4paDmoEGYBjZn8fSk
         eIKS0UMFjdB/9YO6nyRyPvHQcpLMcqYpMauF15eRd0DJr+IuGzlZLf2GukIiPSkueZhm
         2p4Eo2rFNuNOjeUD5wwJ+jK9BLKes1En6DzRgWpiEgyZBgSG/ObM01bQGov2XpfMV6KU
         FLcmvxyDcCEbDTLIifKySJgyNea3Ciggf5vM3fFNFhJ9AVhGSqojlw8y4WCYgg60QeJr
         8+lfW7xf+HT0hwmZS6Jk5ij5GrYluQpdWTRZ3Aea3Z2y8c8wEl01Bm1QwwdeiECrhLp9
         1Lew==
X-Forwarded-Encrypted: i=1; AJvYcCXxGl1mO3wjDucgnAnT0IV3lauMUZX1VRK+ndU+5cRp2PpCgY9nyKASlP2cAVkHwDIjhNE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLSdhDVccMPP5VZZYxwU14OrzUdPTnmC5QtDdtRT7/6sehdfh+
	IEruzt6VPLtqCv7XWN1+ecKyCgkdZkRorp/h/+vvdmzEZUYqqUn+
X-Gm-Gg: ASbGncseTwo+SrP3ESPBklVixfZqdPLcVOrNMIpMDcnp6j3LDswzfaIWsIq51eHpgIi
	/mo3sGaG70SWbBvwcNyRX6KEdgz5QFW5f3TpbDIYf0pahIplLHK/6qnKfl3pn3mCJk20Cbe4LEU
	QMXk4qjAIMAkRNNXlq07O969uimzRB13V8kejBnig9fIo+LniLpehQ+/usEO5cX2D3hf0lgHQJT
	2XNiNAYqSjILDIQuEDc0MP3sctLE1V8AXcvNcSGMcdql4nwPbVNljrWn2dmEJ1Nl8BnDmja5gcU
	vFK+gS5uxc+vW41SyZHbe1TPJARt7I1nZrAjCxIzH00sKFTfKlvh2+BX4iSRmNfbfOsPGldm9ri
	zV/W0OPMCcMakc4Tp
X-Google-Smtp-Source: AGHT+IEe8sgMAhztFQNtqqr0LGad0hITIqcOknp41rMuyGA1xNKnDPBf2YTbKT0jJOJx/ctOt51OJw==
X-Received: by 2002:a05:6214:1c8e:b0:6e6:5e15:d94f with SMTP id 6a1803df08f44-6f4bfc0a70emr54026826d6.27.1745506321434;
        Thu, 24 Apr 2025 07:52:01 -0700 (PDT)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-47e9f5bcf0dsm12547231cf.35.2025.04.24.07.52.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Apr 2025 07:52:00 -0700 (PDT)
Message-ID: <9b128c9e-fe73-46f9-8e83-ae552f6c2531@gmail.com>
Date: Thu, 24 Apr 2025 10:51:59 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/8] zbd: add the recover_zbd_write_error option
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>
References: <20250421123828.82712-1-shinichiro.kawasaki@wdc.com>
 <20250421123828.82712-6-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20250421123828.82712-6-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/21/25 8:38 AM, Shin'ichiro Kawasaki wrote:
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
Changes are needed in cconv.c to enable this new option to work in 
client/server mode.

Vincent

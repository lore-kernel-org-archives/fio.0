Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30F11B87C0
	for <fio@vger.kernel.org>; Wed,  7 May 2025 17:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746638379; cv=none; b=ofGWKtA5VA7oTZMegc1bAl9Y4MgJ4nTZbG/XywsOBYQq73s2ijEoUNRI5RmGkMSpl9MzJazQkLpUp6vKF7vyexjwUteYUXJsbK8nuYUTODJi28Pl+j4fSFuOsua1kixZL0zeo3gCvgugE9LlEIcadr6fJWCDfMsXxvNtOTcZQpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746638379; c=relaxed/simple;
	bh=ddIi99YIlDsT/oyhcJ59SqQrzR1RIEQ1dJWoc+MiJak=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dsoCRuiPc/Cl+TvUU+MEZj8YYFDI6PTy4yP5lHLH1SO+WxWaH9+l1IpKeuAD2uX6OgqMFFloZQqlwprFYOo6XjD9Rx+IDHPeJRQSRwW6O+jtdVtjndQW9YRKEJPCbn1OX5D+uo0AmKjjBCk5sThrP/oo0Y0lmN+/hqTDZORRVuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nmLq4WQ+; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nmLq4WQ+"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-6f549550d96so2182026d6.3
        for <fio@vger.kernel.org>; Wed, 07 May 2025 10:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746638377; x=1747243177; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OVwoomIEZVlnVD+cHr7fwnRzZzyccGsE66SWT/zEdcM=;
        b=nmLq4WQ+cSLdrGs7yhvnRxsZvCpGI9u5pHPrBa5Kwoj/bTCgyWbpr1xcsbsicrw2SE
         6xkXDtspAT9o38hOML6rZADIJAyUZCCV22GUs16jN1AqONa7OxvP6KIPJTy8WmLxgYL7
         1Ca7tMZL/dzMpXJPiOqq8znL6mXKw8g47oRzOZoZLPP1GHQeiTW6G9hehAAuTxaPkP1F
         vS+Njw6/mR10Z+N+lrwvtHtmHc7O5Fjmy19KGZdVdZH8BKwHO8b31DgoScSzabbX7TT+
         eoyx82oybRNG3mTDRMa15lXScTxiKvh5gWK19HtfscS+enwUiNxrjKG7seNvp8d86rBK
         1LBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746638377; x=1747243177;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OVwoomIEZVlnVD+cHr7fwnRzZzyccGsE66SWT/zEdcM=;
        b=uEYrt1d/+YVvMq5z89WdfWSSob+D7r14oexun8S2ctYZAZEiDhaOcRh1ES/bvdH+Vo
         ONsNSajd1KAvaf2rqgM66ehNtzF49ISVACUxXQo8wHJG8RhLD1vNgdS9Nnie9ZxRNVkc
         qfpe50Zbmo8a3dFKbBqLDuLXvH7fVqwg4lNTRfowb10AwAcxT8hxnfzAgwkWk17rdB7I
         JxBT5hExYiAGJD7vXLhq2S0OhmglAmsLWNeLMVks0EDdVBWa6GWzzriU4TA0iMMtlhgF
         cw7CcH2Nyu8hqGJDdx5cRkEK8bo/rD65crzV7Rh7GOU52yqzqs9RvhNlywvLDNSqDePW
         sCNg==
X-Forwarded-Encrypted: i=1; AJvYcCU/WrPdLUeTe2k0ZgoDSs2OnVNjmK/f3xvrwzm/k75Qp1o54IjwHKQoH7ep+7WAWKMOp04=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+LzcM00aTc323n9tVnrlCL+fdDDgcjC+tJjEWDz+mm/F7NlCb
	DW4snXp3L9IHCr06Wf2g6rVkiknmj0RFpDfJR4+QPHXkYb21qRgaBHLR4ZiC
X-Gm-Gg: ASbGncvArBbzri1oW+4/MpDqSOVI9BiqWM8lctBW76RWz6zS2bP/0ZbsifaAVo5jC0y
	yEX6bAJDGSStcZf/IJ+91b7IC0Wjdq4LXUSCiaO2ShVi7FULAG77VsIMT0ybhADT8m2uwBfVacG
	lggdnV6+9SRd8+QP9lKxCtSvpmrVPTwCEUUsqLlGx9sSdJ42g7XnSL9ls/rByQZi12A3Qx0dIBq
	FsZdQ3bXOxagQIfd+z32kQRB1q5KEWYH8LCUyTi+F2agWOz9mXocQdsK0kMYH4pLcqwX5VLW5+q
	oKGo882V+1iVLwIdIAURhlhQ6FNsTqYy/fKdAoMwBJ0BBHbHZzTVZSMTnN3fp0QU8tb4GT1CNAz
	GALyHZsGb+ISjUa5V
X-Google-Smtp-Source: AGHT+IGLJmatGXEtLu5CLfWdSDWT1nuSkVpf7rntuXLok0IdGlMG0LdJHQr+rA2aPhNHXmI5+WcTbw==
X-Received: by 2002:ad4:5b87:0:b0:6f2:b14e:46e6 with SMTP id 6a1803df08f44-6f542a65f8fmr66142946d6.17.1746638376444;
        Wed, 07 May 2025 10:19:36 -0700 (PDT)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f542623c28sm16768296d6.10.2025.05.07.10.19.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 May 2025 10:19:35 -0700 (PDT)
Message-ID: <d120fd1e-22e3-46f4-88a6-559f256e20c5@gmail.com>
Date: Wed, 7 May 2025 13:19:34 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/8] zbd: support continue_on_error for zonemode=zbd
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org,
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Damien Le Moal <dlemoal@kernel.org>
References: <20250425052148.126788-1-shinichiro.kawasaki@wdc.com>
 <174661736206.1785376.17260834205270367848.b4-ty@kernel.dk>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <174661736206.1785376.17260834205270367848.b4-ty@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/7/25 7:29 AM, Jens Axboe wrote:
> 
> On Fri, 25 Apr 2025 14:21:40 +0900, Shin'ichiro Kawasaki wrote:
>> When the continue_on_error options is specified, it is expected that the
>> workload continues to run when non-critical errors happen. However,
>> write workloads with zonemode=zbd option can not continue after errors,
>> if the failed writes cause partial data write on the target device. This
>> partial write creates write pointer gap between the device and fio, then
>> the next write requests by fio will fail due to unaligned write command
>> errors. This restriction results in undesirable test stops during long
>> runs for SMR drives which can recover defect sectors.
>>
>> [...]
> 
> Applied, thanks!
> 
> [1/8] oslib: blkzoned: add blkzoned_move_zone_wp() helper function
>        commit: 4175f4dbec5d1d9e5e0490026e98b1806188e098
> [2/8] ioengine: add move_zone_wp() callback
>        commit: 6f635d6f72ad3d4ae76fff63671a208c27bdaf2d
> [3/8] engines/libzbc: implement move_zone_wp callback
>        commit: d4f6fa5e35d6bd20dd648b3aaaad84a0a9a4fa6e
> [4/8] zbd: introduce zbd_move_zone_wp()
>        commit: 143aaff963694ee3745c204f414e1e27a759a7df
> [5/8] zbd: add the recover_zbd_write_error option
>        commit: 650c4ad385cf7ff320cb34f76784ca63d2daa32e
> [6/8] t/zbd: set badblocks related parameters in run-tests-against-nullb
>        commit: 5cbd1644e0dcfeb55e6cb4717259778ed11cc70e
> [7/8] t/zbd: add the test cases to confirm continue_on_error option
>        commit: b6002e78926bce20bc168d02c83b7c8f5dd37470
> [8/8] t/zbd: add run-tests-against-scsi_debug
>        commit: 4dc6c8da6ed938f12a42f167839100ab551ae8d1
> 
> Best regards,

Shin'ichiro, there are some build failures with macOS and Windows:

https://github.com/axboe/fio/actions/runs/14882253382

Vincent

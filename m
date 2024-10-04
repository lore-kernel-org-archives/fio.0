Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9651FAC29
	for <fio@vger.kernel.org>; Fri,  4 Oct 2024 19:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728068840; cv=none; b=ZeBew2qU0gUn18OMwkjQ+Gp9cYpxll/F0ktCqgebuINm7+XzcdvlN1DiKQ4EaS3fDWQJDDv0S9smP86jOWVrsAXS/OQMhtEap8fr9leA2nolk0T9ZB7gqB7u/429EsVoiNwNby9yb1mJ+qeoUKnDNujDJmx6ztTDugFuUK0mBaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728068840; c=relaxed/simple;
	bh=DN7/bV2hg1P6H+U9lOJQa9hBrGp8vmWFrp7rg/p8Jzg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=fnHc6X3TKDEOx0HNSRMKUZRZipJJTNqE6iWNqgh5je9XS/BmDjV8MXM03P6nb2z4jebuTMXuC6rJD/GNXea7Qk87FrH3jV0rjEXv74dc5SGo+xPHHyRSPL5HNQVdQdKQm581LVISsf9AKUyMHd86mA/ax2FoXi0W/OcBMKreCG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MEAa5CdS; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MEAa5CdS"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-45aeef3ce92so14812091cf.2
        for <fio@vger.kernel.org>; Fri, 04 Oct 2024 12:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728068838; x=1728673638; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ufVPzsAkGuaHN3n0ApEucYNylK24B1Bnq9oECPM8UxE=;
        b=MEAa5CdSkuvPDYuuOTrceTHv6fque3JTq/q7w7PRNjWIBuDSfJR2EKvzMzObsVCnSd
         okzi+qnxLabSTryTa3urV9sft01yk74Z1d5VLsU5VOfFx99D5S5dyFBfHRF05OKzoRQI
         S6hVls6G1c+4+itkbTTjW1lf6SC2jWzO8kmM3AcsvlsU5KqsMTJ60+t0uHXLo/wXVYXx
         uzHpbtDKYGLXDhLitqob3fYWdvCPJf2cplInGGwOtED07jdYQSVMoph/PyHSWk3ioQ3A
         cRzcs+W3JYx4oFHt0XVZb1Ubw/85CTrK0TN0H7qxXDJGrJ5FsnQ+TLdGzH6LffoaMkN3
         mrEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728068838; x=1728673638;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ufVPzsAkGuaHN3n0ApEucYNylK24B1Bnq9oECPM8UxE=;
        b=TaW8HYVvoQA8eEzlt6C8fG2ZL4ADNGqbB80spQJ1Jg02OsA3aJNL3xEcGggVAuMOBB
         8h7kITat+ZbKSy3VJIFxk3M7zOqfjoFqAaPpSg2cgGvgVa4ti0bIsVvfhSPXzZn8yMv0
         pNdFmxT7KIiQwF1p7+KT65p7OQQNEo4qobOWafZ9VWc5utgaxDJ3L/MDbvOPThwPGcAe
         KB/cqHy5MMrLoHVCzfea6Ri+WRFSgxFYnuq5Uxd4aVxTR4a8Rm/fU2EeBH8XA99t+i+M
         6O8z3kFeICMW9wh1eaomnq0Y5j+3k5RMq7HNZCuzXWkN9jx6+L7mv7AvC7nHw2/FUIpX
         8T0w==
X-Forwarded-Encrypted: i=1; AJvYcCVW0c0dcqrrQ1jSQf4pKGizzp2s8ck50/I+/xo5l6tqD7cpqYflUK4hLAvdSbT4B9DOSAc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzlyugYPThz0YFFDo7F3c6G4U3IYfuitZYwM54TCYqGuZgsqMA7
	4Ws4LF70GkKES6y2X8HICazW2xsAmTJmIlpjwX8AtiNqOoQr0EmCMY1Bjg==
X-Google-Smtp-Source: AGHT+IFEWBTKQdY2tpgb43YB6umj+vyLKF2oCQrlaJSB/fLfj62dUAkSfBEzMtG8aihX54FJ5skT5g==
X-Received: by 2002:a05:622a:60b:b0:44f:f83d:469f with SMTP id d75a77b69052e-45d9ba4719bmr47537091cf.14.1728068837720;
        Fri, 04 Oct 2024 12:07:17 -0700 (PDT)
Received: from [192.168.1.220] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-45da75561d5sm1717171cf.50.2024.10.04.12.07.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Oct 2024 12:07:16 -0700 (PDT)
Message-ID: <e8f87ac8-4a2c-488c-ad35-cbaa7428d197@gmail.com>
Date: Fri, 4 Oct 2024 15:07:14 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Verification errors when write phase is aborted midway
To: Prasad Boddupalli <p.boddupalli@gmail.com>, fio@vger.kernel.org
References: <1727778878-30167-mlmmj-071cdab3@vger.kernel.org>
 <CA+VE31bGvC02vyL_drrEtsRn8t9tURTK9F9H9F+jS0vUw7QStg@mail.gmail.com>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <CA+VE31bGvC02vyL_drrEtsRn8t9tURTK9F9H9F+jS0vUw7QStg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/1/24 06:36, Prasad Boddupalli wrote:
> Hello All,
> 
> I am running fio verification in two phases:
> 
> (1) Write phase, with do_verify=0, on the block device /dev/sdb using
> --direct=1 flag. While the write phase is running, the disk is
> disconnected physically. Since data got written to the block device,
> the journal (state file) was created. After the disk was disconnected,
> errors were in-flight writes were reported as follows:
> 
> fio: io_u error on file /dev/sdb: Input/output error: write
> offset=2112716800, buflen=8192
> fio: io_u error on file /dev/sdb: Input/output error: write
> offset=2112724992, buflen=8192
> fio: io_u error on file /dev/sdb: Input/output error: write
> offset=2112733184, buflen=8192
> fio: io_u error on file /dev/sdb: Input/output error: write
> offset=2112741376, buflen=8192
> 
> (2) When I run the verification phase, the verification fails with the
> following errors:
> 
> verify: bad magic header 0, wanted acca at file /dev/sdb offset
> 2112716800, length 8192 (requested block: offset=2112716800,
> length=8192)
> verify: bad magic header 0, wanted acca at file /dev/sdb offset
> 2112724992, length 8192 (requested block: offset=2112724992,
> length=8192)
> verify: bad magic header 0, wanted acca at file /dev/sdb offset
> 2112733184, length 8192 (requested block: offset=2112733184,
> length=8192)
> 
> The offsets reported in the errors in the verification phase
> correspond more or less to the errors reported in the write phase.
> 
> I am assuming that information in the state file will correspond to
> successful writes, writes that were persisted on the disk and
> acknowledged. If so, why was the verification done for data at offsets
> whose writes failed in-flight ?
> 
> Following are the options to write and verification phase:
> 
> write:
> 
> ' --rw=write'
> ' --bs=8K'
> ' --direct=1'
> ' --ioengine=libaio'
> ' --iodepth=16'
> ' --verify=crc32c'
> ' --filename={device_name}'
> ' --size={disk_size}G'
> ' --offset={write_offset}'
> ' --runtime=20m'
> ' --time_based=1'
> ' --do_verify=0'
> 
> verify:
> ' --rw=read'
> ' --bs=8K'
> ' --direct=1'
> ' --ioengine=libaio'
> ' --iodepth=16'
> ' --verify=crc32c'
> ' --filename={device_name}'
> ' --size={disk_size}G'
> ' --offset={write_offset}'
> ' --verify_only=1'
> ' --verify_state_load=1'
> ' --verify_dump=1'
> 

When you build fio from source there is a t/fio-verify-state utility to 
display the contents of the verify state file. Are you able to run it to 
display the contents of your verify state file?

Are you running on a big ending platform? This feature was broken on 
such platforms until recently.

https://github.com/vincentkfu/fio-blog/wiki/Testing-on-a-big-endian-platform

Vincent


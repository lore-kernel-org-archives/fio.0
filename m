Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DAB19CC08
	for <fio@vger.kernel.org>; Tue,  1 Oct 2024 10:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727779051; cv=none; b=lDjnLUMhAGFM9vRMApW7a5cZVfE0WRZeJIgnyPjY532w7SZo8qZhHlJoFGDchCHGsM+rDLAJ+DxUw8D/nr3Vl/Kn3gL+84EwOS5/XGThNBiw3xeDGh3yseqD9254IV8kzLEfqsMIPkveuewpPscHHn+7VrR8G1IdcwA1KDRtoUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727779051; c=relaxed/simple;
	bh=ZPgp3wIEge55YEV39KvIc1iZForklYtgg40f7XFSVN4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=alosFxPuwLAMMJKiiabcw/t9kIr1LB+S/UwwG4oEGXfqcppEsda8ovqNFvMus6/ODNczoLKZ79PRzU2nE4aGFyNcuFr27q9V60fy8ljUnUYH9EaIoadR2g/pzqS2TtNfNDydqXqzKf5hge4xS+5kilIqJEs3TbS76WI3f73nUD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C39aI9z8; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C39aI9z8"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2e082bf1c7fso3913059a91.3
        for <fio@vger.kernel.org>; Tue, 01 Oct 2024 03:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727779049; x=1728383849; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZPgp3wIEge55YEV39KvIc1iZForklYtgg40f7XFSVN4=;
        b=C39aI9z8Y5x4iI2IeBV8duLIHtvCJNtFBcrTiwh0qSpdf61dSb8YFWs3p7J6bZSfBd
         vJpvL9ckPiL6B1GE3I6oykHQIytBjItaoBnfLFyx306fJ+QeUdzlwRi9k94Ru6eOv1uA
         9tXxW/yu/GUG3MITYunQy2HQ+iyGr8+fE7YIKpthVHjU9yQgUATLB+a2+/NhWWzc967m
         Mx8D5qJuPVY/cu/eqzJG08/nRIqvGSrQoJwwXs1A7+CQmjZwR21tYU8UWXriylXuhsD4
         8kJ+sM5s9suLA0rrDS7EIBrsVoZxIb6h3S4H0ZLGf7zEFzI7XvPtPlttqK9B3kqz2qgO
         lSEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727779049; x=1728383849;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZPgp3wIEge55YEV39KvIc1iZForklYtgg40f7XFSVN4=;
        b=AKa91jNmuYais5l6xnIwMYsgJPMEIklDCjrVaBdBx0Nf4E3hc6gpkzsgo4ww2ZMGAS
         9XqKV/2d5ZaaUF7eSTjSHleXb7DOuJk3vlUF61oAMQ8m+eN3di+lKTBCa5WqClk2cMxK
         mNVKQ9HKjeF9x+PmBKtnGy0WgzCh8viMc0HsYXon+LcqX6z+atPK8sLlRIIMNUWmyyKW
         X1A04ojAL152+4WiM951+hCS58QUqO7w3VA3whWOdCIq3QovszXdi5+92GeYvFMiSB2w
         jYEOg+JMxQwy+c8QjjFHXHOTruGhZjqTR6dfBuguH+U8KwvpTO5OAgKJHwSsEHGOxG3B
         xynw==
X-Gm-Message-State: AOJu0YxwMbBEvtD1o8OZ58HgAPnZxX8zgQQX0zvbSdf7dp5aWK8jRSLH
	pXNjrwY32mU3vVHncpb2w6I3Nck/kgF5WFntJSK3fWBdf5HAx3szIKNJpPFVfqRMBgEnnhpS8gF
	EhyncrZu4h/LrS+0F5lu8gccO5rFuYg==
X-Google-Smtp-Source: AGHT+IE0pcCRMQXAsIDynLdocDdsVIT7HU7yk1UMXZzqWOfhHK0X1HTXY0rISwpapPDNSJFvl3a04zWppcKspo7e4uw=
X-Received: by 2002:a17:90a:a40c:b0:2e0:8733:6c78 with SMTP id
 98e67ed59e1d1-2e0b8a1b6ffmr16704993a91.15.1727779049478; Tue, 01 Oct 2024
 03:37:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1727778878-30167-mlmmj-071cdab3@vger.kernel.org>
In-Reply-To: <1727778878-30167-mlmmj-071cdab3@vger.kernel.org>
From: Prasad Boddupalli <p.boddupalli@gmail.com>
Date: Tue, 1 Oct 2024 16:06:52 +0530
Message-ID: <CA+VE31bGvC02vyL_drrEtsRn8t9tURTK9F9H9F+jS0vUw7QStg@mail.gmail.com>
Subject: Verification errors when write phase is aborted midway
To: fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello All,

I am running fio verification in two phases:

(1) Write phase, with do_verify=0, on the block device /dev/sdb using
--direct=1 flag. While the write phase is running, the disk is
disconnected physically. Since data got written to the block device,
the journal (state file) was created. After the disk was disconnected,
errors were in-flight writes were reported as follows:

fio: io_u error on file /dev/sdb: Input/output error: write
offset=2112716800, buflen=8192
fio: io_u error on file /dev/sdb: Input/output error: write
offset=2112724992, buflen=8192
fio: io_u error on file /dev/sdb: Input/output error: write
offset=2112733184, buflen=8192
fio: io_u error on file /dev/sdb: Input/output error: write
offset=2112741376, buflen=8192

(2) When I run the verification phase, the verification fails with the
following errors:

verify: bad magic header 0, wanted acca at file /dev/sdb offset
2112716800, length 8192 (requested block: offset=2112716800,
length=8192)
verify: bad magic header 0, wanted acca at file /dev/sdb offset
2112724992, length 8192 (requested block: offset=2112724992,
length=8192)
verify: bad magic header 0, wanted acca at file /dev/sdb offset
2112733184, length 8192 (requested block: offset=2112733184,
length=8192)

The offsets reported in the errors in the verification phase
correspond more or less to the errors reported in the write phase.

I am assuming that information in the state file will correspond to
successful writes, writes that were persisted on the disk and
acknowledged. If so, why was the verification done for data at offsets
whose writes failed in-flight ?

Following are the options to write and verification phase:

write:

' --rw=write'
' --bs=8K'
' --direct=1'
' --ioengine=libaio'
' --iodepth=16'
' --verify=crc32c'
' --filename={device_name}'
' --size={disk_size}G'
' --offset={write_offset}'
' --runtime=20m'
' --time_based=1'
' --do_verify=0'

verify:
' --rw=read'
' --bs=8K'
' --direct=1'
' --ioengine=libaio'
' --iodepth=16'
' --verify=crc32c'
' --filename={device_name} '
' --size={disk_size}G'
' --offset={write_offset}'
' --verify_only=1'
' --verify_state_load=1'
' --verify_dump=1'

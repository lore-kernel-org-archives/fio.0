Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5BB633F4
	for <fio@vger.kernel.org>; Thu, 25 Jan 2024 14:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706192230; cv=none; b=deD7oGqAtlc9Sr/JTp4zhK63tldqoDWWsso6Hwvr5i0fR8n4AUBUwkSPBlixm/nXGMXbMIX50cJq1xngyLzzHg7Nxc7p4YzHN6uuDoXsNRybdSMx0ulNTjyWLRG3LGkLXB2OHo8vf9nNEvNFQC9JhTPVlyAsOKjpNTtHvZfGSjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706192230; c=relaxed/simple;
	bh=mPEtFEHr7hUa1lFJIAYnGoKcy0Zf+0g2yyCKOlbUTrY=;
	h=Message-ID:Date:MIME-Version:Subject:References:To:From:
	 In-Reply-To:Content-Type; b=klJ9GVXTUBWWLlCgY7u/bXyyGRk212Gc3EYUEYQmJOFQEVbttstbyRl3gb19ZBpKUI/vp+jf/RDVedLuLLoZkPQ9ufWYMVzzvdyAeHC+JUzeJRokA6k/XNW3V/veZaMExM/DbwG+cmwMNUfpuvjHRX7Th4mV/0xhhc+Gi08o8sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WIwVMi8B; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WIwVMi8B"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-429985e952bso35365961cf.3
        for <fio@vger.kernel.org>; Thu, 25 Jan 2024 06:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706192228; x=1706797028; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:to:content-language
         :references:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=f7dXFQB6oi9Az/U0fx8iobVzkwRaOuq7+nDQHfQEp/U=;
        b=WIwVMi8BeLF6JO069mCOvLCmWq/w1FQT3ifWxoRTdbldfurz1yXfAGPtIc0eq6lLPV
         wQKZwYKRMEIgAucwmc6L83Xs7TfDTr4++SzHGmHQiOo1QAvJSHjj78OF3B0rRqzF+7PS
         A0TMGYbW8vZw7AM0y9VBCwg7SB3NaK5uDJBVGOtbwInqBGYSdwmlDnjQyl+xPM/vYv3j
         K0Fqp1BVzDnKr+0Tx5Y041COiBliaUDZPXK80bFuPt5vUnuphV3DoaUFGrA5LKhEGlWQ
         Y8UlDy3cCTTLdwFSApjrIg1b1zzfSp/MNHwxNQDAzUuqn0V27+Q9HQlsDGz6+Slk1Z9y
         pejA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706192228; x=1706797028;
        h=content-transfer-encoding:in-reply-to:from:to:content-language
         :references:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f7dXFQB6oi9Az/U0fx8iobVzkwRaOuq7+nDQHfQEp/U=;
        b=QXcksXAG4xK/88JXlgs89wrQHeoGM5ExHXAjq9Mrvn+nyrc8YlQTW/hyJe4i4xWtEZ
         JHwDrZ9rTN8cy5s/y67TQyh/GN1IHTFvOdfAdvQnEfH04SPwBoN4YbThDaqie5fPW/Li
         AahkNVY73C5kcxoRKY7albSI4Ypf8hemMMzZ1g6sJmNIGCJXxeDeY4bkhYFCzHpd6pWQ
         0GORJm3DMkk4v5uxXP//1Ekb1rAp38VjqtMYBRCEoe1DoyOfPbyfhQkpdC/jUqH9LdM3
         WMZ/0/NjYUJTaXgIF9LqeMpL837SBcayeCMZtp4YzNguaOvSUa+Kb2tXJuEAEFxYoVBu
         ZzDQ==
X-Gm-Message-State: AOJu0Yx64dHe7pz5e2DZnbgqQRof26Z4cxIL12pF4BNUm2H8iBbpEqG4
	gArEXviW3TqAkBvrMtaKnuL08nB9ZKxYZr/u8gfl6q/+oevwuo1S
X-Google-Smtp-Source: AGHT+IEeqoKIjpBI0MYvwM8CXbdI0tF/U48rTpSwIpHMV9c8dBuItz40id9wY1Us3ZmZ1iOj5eMpsw==
X-Received: by 2002:ac8:5913:0:b0:42a:32e8:d4b5 with SMTP id 19-20020ac85913000000b0042a32e8d4b5mr1061196qty.1.1706192227614;
        Thu, 25 Jan 2024 06:17:07 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id t24-20020ac85318000000b0042a0a3d29a2sm5424916qtn.49.2024.01.25.06.17.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jan 2024 06:17:07 -0800 (PST)
Message-ID: <11bfb3be-25b6-496f-b184-0ac322cc3a1b@gmail.com>
Date: Thu, 25 Jan 2024 09:17:06 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Fwd: New Defects reported by Coverity Scan for axboe/fio
References: <65b26a85a9a91_706f22cbd3e77f9987284b@prd-scan-dashboard-0.mail>
Content-Language: en-US
To: Ankit Kumar <ankit.kumar@samsung.com>,
 "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <65b26a85a9a91_706f22cbd3e77f9987284b@prd-scan-dashboard-0.mail>
X-Forwarded-Message-Id: <65b26a85a9a91_706f22cbd3e77f9987284b@prd-scan-dashboard-0.mail>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Ankit, can you take a look at this report?

Vincent

-------- Forwarded Message --------
Subject: New Defects reported by Coverity Scan for axboe/fio
Date: Thu, 25 Jan 2024 14:11:33 +0000 (UTC)
From: scan-admin@coverity.com
To: vincentfu@gmail.com

Hi,

Please find the latest report on new defect(s) introduced to axboe/fio 
found with Coverity Scan.

2 new defect(s) introduced to axboe/fio found with Coverity Scan.


New defect(s) Reported-by: Coverity Scan
Showing 2 of 2 defect(s)


** CID 479113:  Null pointer dereferences  (FORWARD_NULL)
/iolog.c: 865 in setup_log()


________________________________________________________________________________________________________
*** CID 479113:  Null pointer dereferences  (FORWARD_NULL)
/iolog.c: 865 in setup_log()
859     	}
860     861     	if (l->log_offset)
862     		l->log_ddir_mask = LOG_OFFSET_SAMPLE_BIT;
863     	if (l->log_prio)
864     		l->log_ddir_mask |= LOG_PRIO_SAMPLE_BIT;
>>>     CID 479113:  Null pointer dereferences  (FORWARD_NULL)
>>>     Dereferencing null pointer "l->td".
865     	if (l->td->o.log_max == IO_LOG_SAMPLE_BOTH)
866     		l->log_ddir_mask |= LOG_AVG_MAX_SAMPLE_BIT;
867     868     	INIT_FLIST_HEAD(&l->chunk_list);
869     870     	if (l->log_gz && !p->td)

** CID 479112:  Null pointer dereferences  (REVERSE_INULL)
/iolog.c: 870 in setup_log()


________________________________________________________________________________________________________
*** CID 479112:  Null pointer dereferences  (REVERSE_INULL)
/iolog.c: 870 in setup_log()
864     		l->log_ddir_mask |= LOG_PRIO_SAMPLE_BIT;
865     	if (l->td->o.log_max == IO_LOG_SAMPLE_BOTH)
866     		l->log_ddir_mask |= LOG_AVG_MAX_SAMPLE_BIT;
867     868     	INIT_FLIST_HEAD(&l->chunk_list);
869     >>>     CID 479112:  Null pointer dereferences  (REVERSE_INULL)
>>>     Null-checking "p->td" suggests that it may be null, but it has already been dereferenced on all paths leading to the check.
870     	if (l->log_gz && !p->td)
871     		l->log_gz = 0;
872     	else if (l->log_gz || l->log_gz_store) {
873     		mutex_init_pshared(&l->chunk_lock);
874     		mutex_init_pshared(&l->deferred_free_lock);
875     		p->td->flags |= TD_F_COMPRESS_LOG;


________________________________________________________________________________________________________
To view the defects in Coverity Scan visit, 
https://u15810271.ct.sendgrid.net/ls/click?upn=HRESupC-2F2Czv4BOaCWWCy7my0P0qcxCbhZ31OYv50yrQCKGyuE3tVnqEFz86FVmcUJWn9N1t5XfiQkBi4L7K62z78lv86-2B5gTPBve-2FoiHKo-3DU97O_CJKb9IrGtu4qgVSp-2FHFJxhu-2BF5b22amLmwf35hrR-2B4xqB4ty27oyqqqkWSRy-2BoQISm2b-2F6q2HYxVbKK26OMjCW-2B7XQMquvfYmi1jNArSNjeNHzxQfsnY2W6LAVOFKcXjAZ1Yn2NR34DK-2Fzuhyt-2F2hxHDRUTXFUkZCzxTluFT1veB1kVQ1hlVQQKjIkxqCu4MWUZqzAYmttshIZb5osrOWg-3D-3D

   To manage Coverity Scan email notifications for 
"vincentfu@gmail.com", click 
https://u15810271.ct.sendgrid.net/ls/click?upn=HRESupC-2F2Czv4BOaCWWCy7my0P0qcxCbhZ31OYv50yped04pjJnmXOsUBtKYNIXxWFJgho5ClI4ODXGLipjPYnhQuq-2FmXlhvKnFaVkSqTph-2FjtSariYECqKPT6aMGOAxM8cFcHCL8DSw02AQkgwROQJhZRFIUBnJ7eYMo0qb5ys-3DJgFB_CJKb9IrGtu4qgVSp-2FHFJxhu-2BF5b22amLmwf35hrR-2B4xqB4ty27oyqqqkWSRy-2BoQI6nE0XrvIK-2BG63DOOq9XWEMEUcTxoCXAuV2EOSpu9wkNUr7HltJl2QAxB9BJ7hGsd-2B4gQJ6wtn5pSeVUhCt6Wynhkp3dxPa45HJk7LWGGTWkP6SBjDH82VmKBsQzVhLZ14AqH0rqidBRFNm94h9fU9g-3D-3D


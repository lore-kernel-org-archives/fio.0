Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C8C29CEB
	for <fio@vger.kernel.org>; Sun, 27 Apr 2025 17:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745774617; cv=none; b=Eqkj1tnrnoB4uaHLJJ5zgguUoZT6/S1xpqFSwXPS82kjLK7hui4v5P1cjSkjV+AVhAYUolonaEPxmlwU3FCxYuu9Kvr9RJ3KxkhyDbRPbt7y8zpHxPsW2TQV/hw/gZlKjXElluOP+amkoCS7hngp9OOTcuE1GNWsiaEzhO5jvuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745774617; c=relaxed/simple;
	bh=ikkKhWwQ7TzjUOIRuScaD9vmnc05rkeAD6CbPWeMvzQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LFekZP+GX6+ADYowBELtqQft4F2tGtSWK7nHfZQX1w2LUJLbce+VktJzCqMtKhXT9cbRGODpmM/djjm8M4Rei4rcPyeIPP+xGX7gzf1JAllRyKQ+tLFl8T2OswUQAKVqwh4L4m4/gfdsb9SIAutfphvt7GSVtoIhmWE8vC+3Ujk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pcpartpicker.com; spf=pass smtp.mailfrom=pcpartpicker.com; dkim=pass (2048-bit key) header.d=pcpartpicker.com header.i=@pcpartpicker.com header.b=WD4yt5qm; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pcpartpicker.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pcpartpicker.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pcpartpicker.com header.i=@pcpartpicker.com header.b="WD4yt5qm"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5f76a47549cso192176a12.0
        for <fio@vger.kernel.org>; Sun, 27 Apr 2025 10:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google; t=1745774614; x=1746379414; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ikkKhWwQ7TzjUOIRuScaD9vmnc05rkeAD6CbPWeMvzQ=;
        b=WD4yt5qmYnXkIxEX+iUwHaAMSXu7gMVjtSSdHS4YqpiA80x8k4TxChI7L4G2ScbG73
         od1rA5SmXuvQmoafP72zNW7XKJ3nEJob/qetmWSkYNCatfnteJeKhe1NC/Xoo6dIz9fu
         pXNkqVO8aMT0Efy8IqQyA4kJw7x5o+1g8g+Fu73L7NH9fomMlR1oQuJjS7cJv69VLgzp
         Sx5cwG/kS5V90kGhw1SZFqFWssmSF2YH1ri9OgtQJHiIZV982RWvHarbEiXYJHgqdtVV
         RaHo31+ofEXfUpN3ytwuBnoDzkWBs3hdohRjRXhYxJmAGUhtxmKQMZj/w3LR1jBBHARY
         p1kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745774614; x=1746379414;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ikkKhWwQ7TzjUOIRuScaD9vmnc05rkeAD6CbPWeMvzQ=;
        b=uGyPsQiLNJD9p4sfluR76g3ME8LuhtPsBvCPqpYQQ0LfnH68KPOBawe+qReylAX/81
         2xpmkCTSvxohH/O6vbUlaTArLCag0CMiSw+jr7zJsoVCQVhIweV0Ca68+sLJ4VYLGHRA
         aCeOO5dBQBgnJk0YMKA8ztTSJToNmDhckK0bfZAxXm+DQ0qTqBZ1oxvcP+6US2Yo8zDa
         TFXD5i/WaaRQPaf8AOEB4kv0bNCY3QE0V/hYSkXzvW+P4G1U8slCuD+nclEsMGH8tpmH
         fliYpYi/qFPxSX1wpXaBt00dVCbguyV6KJmOZ3tVttdshuYoIedgOba7Cb6p7irwtsho
         ACYA==
X-Gm-Message-State: AOJu0YzxxiJ0WvJAkkOeEVFmHvCEwnxaNaItHhmdvoDq+hMLt4XNXLYR
	cLvgAJf3jdYjhn1d5umLfflWSU7AON86pOSw5wqLOwBRNOdogoxEu8VqjHZZ5d/jRZNImkAAIkX
	rrRtNL23BAXnOquNzKf/QecE8evq8lSQ9S9gb1g==
X-Gm-Gg: ASbGncsFbCx0RhSKR3f3mh7HZ8Wb3XwpQEHFt0GnfnKc91aWO+RTZNIdtQmLLpmuYyv
	QuLDyQR6jeP1rNKRv9dfP9vsU91FIrb7zRR8FobynmTAeZy5Nb3MHhAHc1h3yCgNr+8T9htUU34
	Pd0H1IJt/xV/gfrsWJWhPZLA==
X-Google-Smtp-Source: AGHT+IG3JCHJ0cg9QXAnBuAi0Ltdw58BSO2anjCBPgtPuUEfExP64FKyFo9B1l7pW74kDkE+QUAXAPnlzo6lHRpA7jQ=
X-Received: by 2002:a17:907:989:b0:ac7:4324:f56a with SMTP id
 a640c23a62f3a-ace714278b8mr255148366b.13.1745774613757; Sun, 27 Apr 2025
 10:23:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADqNVTpRsQXDsW034A8SWeWEbpsAUcidWiKgpj+Xm74NYNPjQQ@mail.gmail.com>
 <faad816b-3683-43e6-a700-65eba76d9a0d@kernel.org> <CADqNVTrptG5b4Un=Q9Hqe5WPMTdcaCDtbjzR753j9YWorEBnxA@mail.gmail.com>
 <CADqNVTqM3se6L=qJUh5U3kwpWCCbuR3GjE+xQ+JCQVRL=t60OA@mail.gmail.com> <e5c59cb4-4613-415b-a8df-9926bfecee64@kernel.org>
In-Reply-To: <e5c59cb4-4613-415b-a8df-9926bfecee64@kernel.org>
From: Nick Neumann <nick@pcpartpicker.com>
Date: Sun, 27 Apr 2025 12:23:21 -0500
X-Gm-Features: ATxdqUHyUA6fCH8jIeXTJBcxgTS4HNlGZotqNbeezSDpTSILCq34ZYt56Mu9tSE
Message-ID: <CADqNVTpdEgAgp3tvCEVGq1trdJwMO=EVZ5bwBQppWVfaBUOeFw@mail.gmail.com>
Subject: Re: Performance variation in traditional HDDs?
To: Damien Le Moal <dlemoal@kernel.org>
Cc: fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 23, 2025 at 10:00=E2=80=AFPM Damien Le Moal <dlemoal@kernel.org=
> wrote:
> So these are drive-managed SMR disks, right ?

Yes. I chose these first because they show the largest performance
difference between two "identical" drives. We do an ATA SECURITY ERASE
to reset their state/LBA mapping - it takes longer than a full drive
write.

Here is another set of identical drives
(https://pcpartpicker.com/product/XtjG3C) that just completed and also
show a significant performance difference. These are CMR drives with
the same model number and firmware.

We did three full drive writes on each drive, using the same proper
horizontal mounting and position.

Looking at the average full drive write speed we saw the following
results in MB/s:

Drive 1: 162.72, 162.73, 162.73
Drive 2: 155.69, 155.70, 155.72

Each individual drive is incredibly consistent in its performance. But
drive 1 is over 4% faster than drive 2.

The difference can be seen in a graph comparing one full write run of each:
https://cdna.pcpartpicker.com/static/forever/images/content/221396115ee6bae=
8fbd35135fbc6441e.png

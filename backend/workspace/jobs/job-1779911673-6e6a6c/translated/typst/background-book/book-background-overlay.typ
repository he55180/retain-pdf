#set text(font: "Source Han Sans SC", size: 11.4pt)
#import "@preview/cmarker:0.1.8"
#import "@preview/mitex:0.2.6": mitex
#show math.equation.where(block: false): set math.frac(style: "horizontal")
#let pdftr_fit_size(lo, hi, eps, fits) = {
  if hi - lo <= eps {
    lo
  } else {
    let mid = lo + (hi - lo) / 2
    if fits(mid) {
      pdftr_fit_size(mid, hi, eps, fits)
    } else {
      pdftr_fit_size(lo, mid, eps, fits)
    }
  }
}
#let pdftr_fit_single_line_markdown(markdown, max_size: 10pt, min_size: 9pt, fit_width: none, fit_height: none, weight: "regular", eps: 0.08pt) = {
  layout(size => {
    let allowed-width = if fit_width == none { size.width } else { calc.min(size.width, fit_width) }
    let allowed-height = if fit_height == none { size.height } else { calc.min(size.height, fit_height) }
    let render(text_size) = box(inset: 0pt, clip: false)[#{
      set text(size: text_size, weight: weight)
      set par(leading: 1em)
      cmarker.render(markdown, math: mitex)
    }]
    let fits(text_size) = {
      let measured = measure(render(text_size))
      measured.width <= allowed-width and measured.height <= allowed-height
    }
    let chosen-size = if fits(max_size) {
      max_size
    } else {
      pdftr_fit_size(min_size, max_size, eps, size_pt => fits(size_pt))
    }
    box(width: allowed-width, height: allowed-height, inset: 0pt, clip: false)[#{
      set text(size: chosen-size, weight: weight)
      set par(leading: 1em)
      cmarker.render(markdown, math: mitex)
    }]
  })
}
#let pdftr_fit_markdown(markdown, max_size: 10pt, min_size: 9pt, max_leading: 0.66em, min_leading: 0.54em, fit_height: none, eps: 0.08pt) = {
  layout(size => {
    let allowed-height = if fit_height == none { size.height } else { calc.min(size.height, fit_height) }
    let render(text_size, leading) = block(width: size.width)[#{
      set text(size: text_size)
      set par(leading: leading)
      cmarker.render(markdown, math: mitex)
    }]
    let fits(text_size, leading) = measure(width: size.width, render(text_size, leading)).height <= allowed-height
    if fits(max_size, max_leading) {
      render(max_size, max_leading)
    } else {
      let chosen-size = pdftr_fit_size(min_size, max_size, eps, size_pt => fits(size_pt, min_leading))
      render(chosen-size, min_leading)
    }
  })
}
#set page(width: 596.0pt, height: 842.0pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 1, width: 596.0pt))
#let rp0_item_p001_b002_0_md = "救护车服务协议"
#let rp0_item_p001_b002_0_body = block(width: 399.01pt, height: 17.59pt)[#{ pdftr_fit_single_line_markdown(rp0_item_p001_b002_0_md, max_size: 15.41pt, min_size: 12.0pt, fit_width: 399.01pt, fit_height: 17.59pt, weight: "bold") }]
#context {
  place(top + left, dx: 120.48046747843425pt, dy: 271.7320306396485pt, rp0_item_p001_b002_0_body)
}
#let rp0_item_p001_b003_1_md = "签约双方"
#let rp0_item_p001_b003_1_body = block(width: 101.76pt, height: 18.43pt)[#{ pdftr_fit_single_line_markdown(rp0_item_p001_b003_1_md, max_size: 16.15pt, min_size: 12.0pt, fit_width: 101.76pt, fit_height: 18.43pt, weight: "bold") }]
#context {
  place(top + left, dx: 262.87705586751304pt, dy: 350.2306164550781pt, rp0_item_p001_b003_1_body)
}
#let rp0_item_p001_b005_2_md = "及"
#let rp0_item_p001_b005_2_body = block(width: 49.4pt, height: 20.94pt)[#{ pdftr_fit_single_line_markdown(rp0_item_p001_b005_2_md, max_size: 18.35pt, min_size: 12.0pt, fit_width: 49.4pt, fit_height: 20.94pt, weight: "bold") }]
#context {
  place(top + left, dx: 288.65576171875pt, dy: 463.92488240559896pt, rp0_item_p001_b005_2_body)
}
#let rp0_item_p001_b007_3_md = "提供救护服务予 CHINA HARBOURENGINEERING COMPANYLTD"
#let rp0_item_p001_b007_3_body = block(width: 363.9282872517904pt, height: 31.11669270833329pt)[#{ pdftr_fit_markdown(rp0_item_p001_b007_3_md, max_size: 11.73pt, min_size: 10.93pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 31.11669270833329pt) }]
#context {
  place(top + left, dx: 131.48614832560222pt, dy: 658.3811881510417pt, rp0_item_p001_b007_3_body)
}
#pagebreak()
#set page(width: 596.0pt, height: 842.0pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 2, width: 596.0pt))
#let rp1_item_p002_b000_0_md = "本协议日期：2026年3月25日"
#let rp1_item_p002_b000_0_body = block(width: 381.7pt, height: 10.47pt)[#{ pdftr_fit_single_line_markdown(rp1_item_p002_b000_0_md, max_size: 9.58pt, min_size: 7.38pt, fit_width: 381.7pt, fit_height: 10.47pt, weight: "bold") }]
#context {
  place(top + left, dx: 107.3477274576823pt, dy: 202.25479899088538pt, rp1_item_p002_b000_0_body)
}
#let rp1_item_p002_b001_1_md = "签约双方"
#let rp1_item_p002_b001_1_body = block(width: 55.74pt, height: 11.31pt)[#{ pdftr_fit_single_line_markdown(rp1_item_p002_b001_1_md, max_size: 10.35pt, min_size: 8.15pt, fit_width: 55.74pt, fit_height: 11.31pt, weight: "bold") }]
#context {
  place(top + left, dx: 283.7349487304688pt, dy: 230.67473144531252pt, rp1_item_p002_b001_1_body)
}
#let rp1_item_p002_b002_2_md = "坦桑尼亚紧急加医疗服务中心有限公司，一家根据《公司法》[第212章，2002年修订版]在坦桑尼亚注册成立的组织，其总部位于坦桑尼亚达累斯萨拉姆乌尔西诺庄园查托街18号地块，邮政信箱10391，电话：+255 753 533495，电子邮箱：info@eplus.co.tz（以下称为“E-Plus”，该表述在上下文允许的情况下应包括其继承人和允许的受让人）为一方。"
#let rp1_item_p002_b002_2_body = block(width: 404.54348347981767pt, height: 80.58413533528648pt)[#{ pdftr_fit_markdown(rp1_item_p002_b002_2_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 80.58413533528648pt) }]
#context {
  place(top + left, dx: 108.85043029785156pt, dy: 263.99926330566404pt, rp1_item_p002_b002_2_body)
}
#let rp1_item_p002_b003_3_md = "及"
#let rp1_item_p002_b003_3_body = block(width: 27.45pt, height: 13.4pt)[#{ pdftr_fit_single_line_markdown(rp1_item_p002_b003_3_md, max_size: 12.26pt, min_size: 10.06pt, fit_width: 27.45pt, fit_height: 13.4pt, weight: "bold") }]
#context {
  place(top + left, dx: 298.264555867513pt, dy: 357.10815836588546pt, rp1_item_p002_b003_3_body)
}
#let rp1_item_p002_b004_4_md = "CHINAHARBOURENGINEERINGCOMPANYLIMITED，一家根据坦桑尼亚《公司法》注册成立的组织（注册号：99870），税号：121-046164，其总部位于坦桑尼亚达累斯萨拉姆Gerezani区Lugoda街，邮政信箱：32550，电话：+255612612688，电子邮件：（以下称为“客户”，该表述在上下文允许的情况下应包含其继承人和许可受让人）的另一方。"
#let rp1_item_p002_b004_4_body = block(width: 400.522151184082pt, height: 72.60555257161451pt)[#{ pdftr_fit_markdown(rp1_item_p002_b004_4_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 72.60555257161451pt) }]
#context {
  place(top + left, dx: 110.01449305216471pt, dy: 388.09238566080734pt, rp1_item_p002_b004_4_body)
}
#let rp1_item_p002_b005_5_md = "序言"
#let rp1_item_p002_b005_5_body = block(width: 64.6pt, height: 11.31pt)[#{ pdftr_fit_single_line_markdown(rp1_item_p002_b005_5_md, max_size: 10.35pt, min_size: 8.15pt, fit_width: 64.6pt, fit_height: 11.31pt, weight: "bold") }]
#context {
  place(top + left, dx: 102.36342875162761pt, dy: 475.5507486979167pt, rp1_item_p002_b005_5_body)
}
#let rp1_item_p002_b006_6_md = "鉴于客户是一家正式注册的实体，成立于坦桑尼亚，提供银行及其他相关服务。"
#let rp1_item_p002_b006_6_body = block(width: 402.934966023763pt, height: 23.536948242187464pt)[#{ pdftr_fit_markdown(rp1_item_p002_b006_6_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.75em, min_leading: 0.67em, fit_height: 23.536948242187464pt) }]
#context {
  place(top + left, dx: 110.50127716064452pt, dy: 500.68867919921877pt, rp1_item_p002_b006_6_body)
}
#let rp1_item_p002_b007_7_md = "鉴于客户有意安排由 E-Plus 提供救护车服务。"
#let rp1_item_p002_b007_7_body = block(width: 403.73918609619136pt, height: 24.7337500000001pt)[#{ pdftr_fit_markdown(rp1_item_p002_b007_7_md, max_size: 11.71pt, min_size: 10.91pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 24.7337500000001pt) }]
#context {
  place(top + left, dx: 110.09915186564128pt, dy: 537.64923828125pt, rp1_item_p002_b007_7_body)
}
#let rp1_item_p002_b008_8_md = "且鉴于E-Plus已获得许可并同意根据本协议条款和条件提供配备操作员及护理人员的全套装备救护车。"
#let rp1_item_p002_b008_8_body = block(width: 402.9349273681641pt, height: 37.100625000000036pt)[#{ pdftr_fit_markdown(rp1_item_p002_b008_8_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 37.100625000000036pt) }]
#context {
  place(top + left, dx: 111.34787445068359pt, dy: 574.5419319661459pt, rp1_item_p002_b008_8_body)
}
#let rp1_item_p002_b009_9_md = "现因此，客户与EPlus基于本协议下文所列或述及的规定、相互承诺、约定和条件，达成如下协议："
#let rp1_item_p002_b009_9_body = block(width: 403.73919576009115pt, height: 23.138052571614594pt)[#{ pdftr_fit_markdown(rp1_item_p002_b009_9_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.74em, min_leading: 0.66em, fit_height: 23.138052571614594pt) }]
#context {
  place(top + left, dx: 110.52244110107421pt, dy: 623.3261356608073pt, rp1_item_p002_b009_9_body)
}
#let rp1_item_p002_b010_10_md = "1. 生效与期限："
#let rp1_item_p002_b010_10_body = block(width: 165.52pt, height: 10.89pt)[#{ pdftr_fit_single_line_markdown(rp1_item_p002_b010_10_md, max_size: 9.96pt, min_size: 7.76pt, fit_width: 165.52pt, fit_height: 10.89pt, weight: "bold") }]
#context {
  place(top + left, dx: 122.24773178100587pt, dy: 660.1699145507813pt, rp1_item_p002_b010_10_body)
}
#let rp1_item_p002_b011_11_md = "本协议自2026年4月1日起生效，有效期至2026年9月30日。若客户有意续签本协议，客户应通知RENG"
#let rp1_item_p002_b011_11_body = block(width: 370.36234741210933pt, height: 22.73908040364597pt)[#{ pdftr_fit_markdown(rp1_item_p002_b011_11_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.73em, min_leading: 0.65em, fit_height: 22.73908040364597pt) }]
#context {
  place(top + left, dx: 144.3543284098307pt, dy: 685.6995109049478pt, rp1_item_p002_b011_11_body)
}
#pagebreak()
#set page(width: 596.0pt, height: 842.0pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 3, width: 596.0pt))
#let rp2_item_p003_b000_0_md = "E-plus 在合同期满前至少一（1）个月。本协议仍应可按照本文所载规定予以终止。"
#let rp2_item_p003_b000_0_body = block(width: 371.9708938598633pt, height: 24.334816080729126pt)[#{ pdftr_fit_markdown(rp2_item_p003_b000_0_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 24.334816080729126pt) }]
#context {
  place(top + left, dx: 141.01029586791992pt, dy: 116.21212890625pt, rp2_item_p003_b000_0_body)
}
#let rp2_item_p003_b001_1_md = "2. 标准："
#let rp2_item_p003_b001_1_body = block(width: 72.2pt, height: 12.57pt)[#{ pdftr_fit_single_line_markdown(rp2_item_p003_b001_1_md, max_size: 11.5pt, min_size: 9.3pt, fit_width: 72.2pt, fit_height: 12.57pt, weight: "bold") }]
#context {
  place(top + left, dx: 116.0993626912435pt, dy: 217.92107503255212pt, rp2_item_p003_b001_1_body)
}
#let rp2_item_p003_b002_2_md = "E-Plus承诺将按照经批准的国民健康与安全标准、陆路运输监管局（LATRA）以及E-Plus要求的其他国际标准，向客户提供配备齐全的救护车服务。救护车服务应每周7天、每天24小时（24/7）提供，不分周末和公共假日。鉴于该服务的重要性，双方明确约定，救护车服务将不间断地每天24小时、每周7天可用。"
#let rp2_item_p003_b002_2_body = block(width: 371.97088419596355pt, height: 82.97773885091144pt)[#{ pdftr_fit_markdown(rp2_item_p003_b002_2_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 82.97773885091144pt) }]
#context {
  place(top + left, dx: 140.16370747884116pt, dy: 245.82665181477867pt, rp2_item_p003_b002_2_body)
}
#let rp2_item_p003_b003_3_md = "3. 客户的义务："
#let rp2_item_p003_b003_3_body = block(width: 134.27pt, height: 11.31pt)[#{ pdftr_fit_single_line_markdown(rp2_item_p003_b003_3_md, max_size: 10.35pt, min_size: 8.15pt, fit_width: 134.27pt, fit_height: 11.31pt, weight: "bold") }]
#context {
  place(top + left, dx: 118.07827250162761pt, dy: 345.2614420572917pt, rp2_item_p003_b003_3_body)
}
#let rp2_item_p003_b004_4_md = "a. 应患者随时询问，客户须联系E-Plus并要求提供救护车服务。呼叫方应表明自己为客户代表，并提供紧急情况的详细说明，包括但不限于：紧急性质、紧急地点、现场可提供更多紧急情况信息的人员联系方式、受影响伤员/患者人数。"
#let rp2_item_p003_b004_4_body = block(width: 356.2877858479818pt, height: 70.61088297526044pt)[#{ pdftr_fit_markdown(rp2_item_p003_b004_4_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 70.61088297526044pt) }]
#context {
  place(top + left, dx: 156.6828180948893pt, dy: 371.47733439127603pt, rp2_item_p003_b004_4_body)
}
#let rp2_item_p003_b005_5_md = "客户应通过电子邮件（dispatch@eplus.co.tz 和 info@eplus.co.tz)向 E-Plus 提交一份书面付款保证，声明客户同意按照附件3中规定的费率就救护车服务接受开票。"
#let rp2_item_p003_b005_5_body = block(width: 354.27713419596364pt, height: 35.504889322916654pt)[#{ pdftr_fit_markdown(rp2_item_p003_b005_5_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 35.504889322916654pt) }]
#context {
  place(top + left, dx: 158.32308247884114pt, dy: 458.63114095052083pt, rp2_item_p003_b005_5_body)
}
#let rp2_item_p003_b006_6_md = "c. 客户应支付不可退还的预聘费，金额为2,700,000坦桑尼亚先令，覆盖合同期内的六（6）个月。该预聘费不包括救护车服务费用，救护车服务费用将按照附件3中所规定的费率另行收取。"
#let rp2_item_p003_b006_6_body = block(width: 357.09205423990886pt, height: 49.06856608072917pt)[#{ pdftr_fit_markdown(rp2_item_p003_b006_6_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 49.06856608072917pt) }]
#context {
  place(top + left, dx: 156.70398305257163pt, dy: 507.0206486002604pt, rp2_item_p003_b006_6_body)
}
#let rp2_item_p003_b007_7_md = "4. 发票与付款"
#let rp2_item_p003_b007_7_body = block(width: 129.63pt, height: 14.66pt)[#{ pdftr_fit_single_line_markdown(rp2_item_p003_b007_7_md, max_size: 13.41pt, min_size: 11.21pt, fit_width: 129.63pt, fit_height: 14.66pt, weight: "bold") }]
#context {
  place(top + left, dx: 117.53856709798177pt, dy: 569.7083024088541pt, rp2_item_p003_b007_7_body)
}
#let rp2_item_p003_b008_8_md = "a. E-Plus 应根据本协议附件3所载的约定费率计算并提供发票，该等费率可随现行市场价格以及双方届时约定的调整而增减。（在合同期限内，客户应在收到完整、正确且无争议的原始发票及对账单后三十（30）天内，在服务已令人满意地交付并使客户满意的情况下，后付该等款项。）"
#let rp2_item_p003_b008_8_body = block(width: 353.0707509358724pt, height: 83.37669189453118pt)[#{ pdftr_fit_markdown(rp2_item_p003_b008_8_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 83.37669189453118pt) }]
#context {
  place(top + left, dx: 156.17486012776692pt, dy: 599.3605432128907pt, rp2_item_p003_b008_8_body)
}
#let rp2_item_p003_b009_9_md = "b. 救护车服务免于纳税。若法律就此发生变更，本协议附件3中规定的费率应"
#let rp2_item_p003_b009_9_body = block(width: 349.4515818277995pt, height: 24.334816080729297pt)[#{ pdftr_fit_markdown(rp2_item_p003_b009_9_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 24.334816080729297pt) }]
#context {
  place(top + left, dx: 156.0796188354492pt, dy: 696.3603019205729pt, rp2_item_p003_b009_9_body)
}
#pagebreak()
#set page(width: 596.0pt, height: 842.0pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 4, width: 596.0pt))
#let rp3_item_p004_b000_0_md = "经双方协商修订，以包含服务期限内所有适用的税费、关税及征收款项。"
#let rp3_item_p004_b000_0_body = block(width: 324.11731109619143pt, height: 22.739089965820312pt)[#{ pdftr_fit_markdown(rp3_item_p004_b000_0_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.73em, min_leading: 0.65em, fit_height: 22.739089965820312pt) }]
#context {
  place(top + left, dx: 173.19133936564126pt, dy: 116.58559926350915pt, rp3_item_p004_b000_0_body)
}
#let rp3_item_p004_b001_1_md = "c. 所有发票均应包含服务提供方的纳税人登记号/税务识别号及完整地址。"
#let rp3_item_p004_b001_1_body = block(width: 338.99617970784504pt, height: 23.138033447265627pt)[#{ pdftr_fit_markdown(rp3_item_p004_b001_1_md, max_size: 11.71pt, min_size: 10.91pt, max_leading: 0.74em, min_leading: 0.66em, fit_height: 23.138033447265627pt) }]
#context {
  place(top + left, dx: 157.07436396280926pt, dy: 152.2475217692057pt, rp3_item_p004_b001_1_body)
}
#let rp3_item_p004_b003_2_md = "账户名称："
#let rp3_item_p004_b003_2_body = block(width: 73.18777618408205pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp3_item_p004_b003_2_md, max_size: 12.26pt, min_size: 10.06pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 166.5879305521647pt, dy: 212.18061279296876pt, rp3_item_p004_b003_2_body)
}
#let rp3_item_p004_b005_3_md = "银行名称："
#let rp3_item_p004_b005_3_body = block(width: 59.51532948811848pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp3_item_p004_b005_3_md, max_size: 11.88pt, min_size: 9.68pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 166.22812932332357pt, dy: 241.44132864583338pt, rp3_item_p004_b005_3_body)
}
#let rp3_item_p004_b007_4_md = "分行："
#let rp3_item_p004_b007_4_body = block(width: 38.60455423990888pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp3_item_p004_b007_4_md, max_size: 9.2pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 166.52443389892576pt, dy: 255.35725068359386pt, rp3_item_p004_b007_4_body)
}
#let rp3_item_p004_b009_5_md = "TZS 账号：0264997001 (TZS)"
#let rp3_item_p004_b009_5_body = block(width: 190.20782216389972pt, height: 11.967941080729133pt)[#{ pdftr_fit_markdown(rp3_item_p004_b009_5_md, max_size: 11.5pt, min_size: 9.3pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 11.967941080729133pt) }]
#context {
  place(top + left, dx: 169.66740544637042pt, dy: 266.4679033528646pt, rp3_item_p004_b009_5_body)
}
#let rp3_item_p004_b011_6_md = "SWIFT 代码："
#let rp3_item_p004_b011_6_body = block(width: 56.70042877197267pt, height: 12.76580891927074pt)[#{ pdftr_fit_markdown(rp3_item_p004_b011_6_md, max_size: 12.26pt, min_size: 10.06pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 12.76580891927074pt) }]
#context {
  place(top + left, dx: 165.73075383504232pt, dy: 290.2595008463543pt, rp3_item_p004_b011_6_body)
}
#let rp3_item_p004_b013_7_md = "5. E-Plus的义务："
#let rp3_item_p004_b013_7_body = block(width: 119.92pt, height: 12.57pt)[#{ pdftr_fit_single_line_markdown(rp3_item_p004_b013_7_md, max_size: 11.5pt, min_size: 9.3pt, fit_width: 119.92pt, fit_height: 12.57pt, weight: "bold") }]
#context {
  place(top + left, dx: 117.71847127278646pt, dy: 329.52718476562495pt, rp3_item_p004_b013_7_body)
}
#let rp3_item_p004_b014_8_md = "a. E-Plus 承诺依照国家健康与安全标准、陆路交通管理局（LATRA）及 E-Plus 建议和要求的任何其他国际标准，配置并投入完全装备的救护车，以便向客户提供救护服务。救护服务须每周七天、每天二十四小时（24/7）不间断提供，不受周末及公共假日影响。鉴于该服务的重要性，双方明确约定，救护服务必须确保每周七天、每天二十四小时无故障可用。"
#let rp3_item_p004_b014_8_body = block(width: 357.4941884358724pt, height: 93.74887817382807pt)[#{ pdftr_fit_markdown(rp3_item_p004_b014_8_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 93.74887817382807pt) }]
#context {
  place(top + left, dx: 156.71456553141275pt, dy: 357.7765213134767pt, rp3_item_p004_b014_8_body)
}
#let rp3_item_p004_b015_9_md = "E-Plus 应运营一个全天 24 小时可用的联络点，客户可通过该联络点在紧急情况下请求救护车服务。该服务通过致电 E-Plus 紧急调度中心（dispatch@eplus.co.tz）启动。"
#let rp3_item_p004_b015_9_body = block(width: 355.0814025878906pt, height: 60.23863932291664pt)[#{ pdftr_fit_markdown(rp3_item_p004_b015_9_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 60.23863932291664pt) }]
#context {
  place(top + left, dx: 158.34424743652343pt, dy: 468.74738984375006pt, rp3_item_p004_b015_9_body)
}
#let rp3_item_p004_b016_10_md = "E-Plus 应以最小化到达紧急地点并开始提供护理所需时间的方式，在达累斯萨拉姆部署并调配其救护车。"
#let rp3_item_p004_b016_10_body = block(width: 355.4835367838542pt, height: 36.70169108072923pt)[#{ pdftr_fit_markdown(rp3_item_p004_b016_10_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 36.70169108072923pt) }]
#context {
  place(top + left, dx: 157.93153076171873pt, dy: 543.5385283528647pt, rp3_item_p004_b016_10_body)
}
#let rp3_item_p004_b017_11_md = "d. E-Plus 须根据E-Plus标准程序的要求，填写所有必要的文件。其中部分文件包括用药记录、转运记录、患者初步评估等。该清单并非详尽无遗，仅为所需表格的示意说明。"
#let rp3_item_p004_b017_11_body = block(width: 356.6899200439452pt, height: 59.83970540364567pt)[#{ pdftr_fit_markdown(rp3_item_p004_b017_11_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 59.83970540364567pt) }]
#context {
  place(top + left, dx: 156.27010142008461pt, dy: 594.3556295898439pt, rp3_item_p004_b017_11_body)
}
#let rp3_item_p004_b018_12_md = "e. E-Plus 作为约定服务的一部分，应确保在提供服务时使用其自有设施，包括车辆、工具、机器、器械和设备，且不产生额外费用，此费用已包含在约定合同价款内。"
#let rp3_item_p004_b018_12_body = block(width: 356.6899200439452pt, height: 38.29738850911451pt)[#{ pdftr_fit_markdown(rp3_item_p004_b018_12_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 38.29738850911451pt) }]
#context {
  place(top + left, dx: 156.27010142008461pt, dy: 669.6348243326825pt, rp3_item_p004_b018_12_body)
}
#pagebreak()
#set page(width: 596.0pt, height: 842.0pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 5, width: 596.0pt))
#let rp4_item_p005_b000_0_md = "f. 确保其车辆/救护车根据所有适用法律（包括所有国家交通与安全管理局规则和条例、土地运输监管局 (LATRA)）持有所有必要的执照、许可证、批准、许可和授权，并且此类车辆保持良好维修状态。"
#let rp4_item_p005_b000_0_body = block(width: 355.8856516520183pt, height: 61.03650716145826pt)[#{ pdftr_fit_markdown(rp4_item_p005_b000_0_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 61.03650716145826pt) }]
#context {
  place(top + left, dx: 156.24893646240233pt, dy: 116.53466389973961pt, rp4_item_p005_b000_0_body)
}
#let rp4_item_p005_b001_1_md = "应客户要求，向客户提供所有必要的文件，包括车辆/救护车注册号、有效的综合保险单以及其人员（包括其救护车操作员）的详细信息。"
#let rp4_item_p005_b001_1_body = block(width: 356.68992004394534pt, height: 37.499558919270896pt)[#{ pdftr_fit_markdown(rp4_item_p005_b001_1_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 37.499558919270896pt) }]
#context {
  place(top + left, dx: 155.8468022664388pt, dy: 192.17461832682287pt, rp4_item_p005_b001_1_body)
}
#let rp4_item_p005_b002_2_md = "h. 确保其驾驶救护车的人员持有有效驾驶执照，并始终遵守所有交通规则和公路法规；同时确保其始终持有有效的无犯罪记录证明和警方清关证明，并具备驾驶救护车所需的驾驶经验；"
#let rp4_item_p005_b002_2_body = block(width: 355.88565165201817pt, height: 49.06856608072914pt)[#{ pdftr_fit_markdown(rp4_item_p005_b002_2_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 49.06856608072914pt) }]
#context {
  place(top + left, dx: 155.8256373087565pt, dy: 243.47127115885414pt, rp4_item_p005_b002_2_body)
}
#let rp4_item_p005_b003_3_md = "随时就与提供服务相关的所有事务向客户保持沟通。在不限制本条通用性的前提下，E-Plus 的技术人员（须在正常工作日内保持可用，并有权代表 E-Plus 行事）应按照要求协调、配合并向客户提供信息；"
#let rp4_item_p005_b003_3_body = block(width: 355.08139292399085pt, height: 71.00979777018216pt)[#{ pdftr_fit_markdown(rp4_item_p005_b003_3_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 71.00979777018216pt) }]
#context {
  place(top + left, dx: 157.07435989379883pt, dy: 307.4063865152996pt, rp4_item_p005_b003_3_body)
}
#let rp4_item_p005_b004_4_md = "确保其人员在值班期间不得酗酒或使用其他违禁物质；"
#let rp4_item_p005_b004_4_body = block(width: 355.88564198811855pt, height: 26.728381347656295pt)[#{ pdftr_fit_markdown(rp4_item_p005_b004_4_md, max_size: 11.71pt, min_size: 10.91pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 26.728381347656295pt) }]
#context {
  place(top + left, dx: 155.40234807332357pt, dy: 392.5697896321614pt, rp4_item_p005_b004_4_body)
}
#let rp4_item_p005_b005_5_md = "k. 确保根据本协议指派给客户的人员在值班时，自费并根据适用法律配备合适的制服以及所有其他必要的个人防护装备和服装（PPE），并确保此类制服定期清洗并保持整洁状态；"
#let rp4_item_p005_b005_5_body = block(width: 355.88565165201817pt, height: 60.23863932291664pt)[#{ pdftr_fit_markdown(rp4_item_p005_b005_5_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 60.23863932291664pt) }]
#context {
  place(top + left, dx: 155.8256373087565pt, dy: 432.6836181640625pt, rp4_item_p005_b005_5_body)
}
#let rp4_item_p005_b006_6_md = "E-Plus 应确保所需设备和用品始终处于良好工作状态。所需设备和用品的清单见附件 2。"
#let rp4_item_p005_b006_6_body = block(width: 355.0813832600911pt, height: 37.898492838541586pt)[#{ pdftr_fit_markdown(rp4_item_p005_b006_6_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 37.898492838541586pt) }]
#context {
  place(top + left, dx: 156.65107065836588pt, dy: 505.815361328125pt, rp4_item_p005_b006_6_body)
}
#let rp4_item_p005_b007_7_md = "m. E-Plus并非客户的代理人，且不得以任何方式表明其为客户的代理人。E-Plus为独立顾问，客户或其员工在任何情况下均不对E-Plus、其代理人和雇员以及任何根据E-Plus指示行事之人的作为或不作为所引起的任何 misconduct、疏忽或任何其他可能涉及任何责任的问题承担责任。"
#let rp4_item_p005_b007_7_body = block(width: 357.49417877197266pt, height: 71.80764648437503pt)[#{ pdftr_fit_markdown(rp4_item_p005_b007_7_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 71.80764648437503pt) }]
#context {
  place(top + left, dx: 154.59807968139648pt, dy: 558.6738134765625pt, rp4_item_p005_b007_7_body)
}
#let rp4_item_p005_b008_8_md = "E-Plus提供的服务应符合最高临床和专业标准。E-Plus应遵守所有关于服务提供的适用法律、法规和标准。E-Plus雇佣的所有人员应能胜任其职责，并持有并维持其在各自角色中适用且有效的证书/执照/资质。"
#let rp4_item_p005_b008_8_body = block(width: 357.09204457600913pt, height: 62.233308919270826pt)[#{ pdftr_fit_markdown(rp4_item_p005_b008_8_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 62.233308919270826pt) }]
#context {
  place(top + left, dx: 154.58749720255534pt, dy: 646.6424194335938pt, rp4_item_p005_b008_8_body)
}

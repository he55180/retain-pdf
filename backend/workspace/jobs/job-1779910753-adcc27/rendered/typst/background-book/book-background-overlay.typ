#set text(font: "Source Han Sans HW", size: 11.4pt)
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
#set page(width: 595.3200073242188pt, height: 841.9200439453125pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 1, width: 595.3200073242188pt))
#let rp0_item_p001_b006_0_md = "MoM- 第15周 2026年5月14日"
#let rp0_item_p001_b006_0_body = block(width: 141.45699999999994pt, height: 12.998999999999995pt)[#{ pdftr_fit_markdown(rp0_item_p001_b006_0_md, max_size: 12.74pt, min_size: 10.54pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 12.998999999999995pt) }]
#context {
  place(top + left, dx: 408.377pt, dy: 173.983pt, rp0_item_p001_b006_0_body)
}
#let rp0_item_p001_b007_1_md = "<table><tr><td>日期/开始时间：</td><td>2026年5月14日（星期四）/ 14:35</td></tr><tr><td rowspan=\"2\">地点：</td><td>现场营地办公室承包商会议室</td></tr><tr><td>达累斯萨拉姆</td></tr><tr><td>参会人员：</td><td>见附件名单</td></tr></table>"
#let rp0_item_p001_b007_1_body = block(width: 497.34999999999997pt)[#{ set text(size: 11.4pt); set par(leading: 0.72em); cmarker.render(rp0_item_p001_b007_1_md, math: mitex) }]
#context {
  place(top + left, dx: 55.983pt, dy: 206.48pt, rp0_item_p001_b007_1_body)
}
#let rp0_item_p001_b008_2_md = "<table><tr><td>分发名单</td><td>姓名</td><td>电子邮箱</td></tr><tr><td>坦桑尼亚港务局（TPA）局长</td><td>Plasduce Mbossa</td><td>dg@ports.go.tz</td></tr><tr><td>坦桑尼亚港务局（TPA）项目工程师（PE）</td><td>Twaha Msita</td><td>twaha.msita@ports.go.tz</td></tr><tr><td>INROS LACKNER 工程师（En）</td><td>Klaus Richter</td><td>daressalaam.port@inros-lackner.de</td></tr><tr><td>承包商代表——中国港湾（CHEC）</td><td>Bian Liang</td><td>tzdmgp@chec.bj.cn</td></tr></table>"
#let rp0_item_p001_b008_2_body = block(width: 496.34999999999997pt)[#{ set text(size: 11.4pt); set par(leading: 0.72em); cmarker.render(rp0_item_p001_b008_2_md, math: mitex) }]
#context {
  place(top + left, dx: 56.483pt, dy: 290.972pt, rp0_item_p001_b008_2_body)
}
#let rp0_item_p001_b010_3_md = "1. 会议开幕"
#let rp0_item_p001_b010_3_body = block(width: 124.96199999999999pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp0_item_p001_b010_3_md, max_size: 13.23pt, min_size: 11.03pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 76.977pt, dy: 415.96pt, rp0_item_p001_b010_3_body)
}
#let rp0_item_p001_b011_4_md = "2. 承包商开工准备情况"
#let rp0_item_p001_b011_4_body = block(width: 226.931pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp0_item_p001_b011_4_md, max_size: 12.74pt, min_size: 10.54pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 76.977pt, dy: 446.3934pt, rp0_item_p001_b011_4_body)
}
#let rp0_item_p001_b012_5_md = "3. 合同事项"
#let rp0_item_p001_b012_5_body = block(width: 113.965pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp0_item_p001_b012_5_md, max_size: 11.76pt, min_size: 9.56pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 76.977pt, dy: 460.3924pt, rp0_item_p001_b012_5_body)
}
#let rp0_item_p001_b013_6_md = "1. 施工方法说明"
#let rp0_item_p001_b013_6_body = block(width: 171.94799999999998pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp0_item_p001_b013_6_md, max_size: 12.74pt, min_size: 10.54pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 100.969pt, dy: 487.56179999999995pt, rp0_item_p001_b013_6_body)
}
#let rp0_item_p001_b014_7_md = "2. 劳工、材料与设备"
#let rp0_item_p001_b014_7_body = block(width: 207.93699999999998pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp0_item_p001_b014_7_md, max_size: 11.76pt, min_size: 9.56pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 99.97pt, dy: 516.867pt, rp0_item_p001_b014_7_body)
}
#let rp0_item_p001_b015_8_md = "3. 项目管理设施"
#let rp0_item_p001_b015_8_body = block(width: 84.47399999999999pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp0_item_p001_b015_8_md, max_size: 12.25pt, min_size: 10.05pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 100.47pt, dy: 544.0364pt, rp0_item_p001_b015_8_body)
}
#let rp0_item_p001_b016_9_md = "4. 日报、周报与月报"
#let rp0_item_p001_b016_9_body = block(width: 187.44400000000002pt, height: 13.999000000000024pt)[#{ pdftr_fit_markdown(rp0_item_p001_b016_9_md, max_size: 13.72pt, min_size: 11.52pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 13.999000000000024pt) }]
#context {
  place(top + left, dx: 100.969pt, dy: 572.2153999999999pt, rp0_item_p001_b016_9_body)
}
#let rp0_item_p001_b017_10_md = "4. 竣工后运营简报（АОВ）"
#let rp0_item_p001_b017_10_body = block(width: 44.98599999999999pt, height: 11.499000000000024pt)[#{ pdftr_fit_markdown(rp0_item_p001_b017_10_md, max_size: 11.27pt, min_size: 9.07pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 11.499000000000024pt) }]
#context {
  place(top + left, dx: 77.477pt, dy: 523.3864pt, rp0_item_p001_b017_10_body)
}
#let rp0_item_p001_b018_11_md = "1. 新缺陷"
#let rp0_item_p001_b018_11_body = block(width: 84.475pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp0_item_p001_b018_11_md, max_size: 11.76pt, min_size: 9.56pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 101.469pt, dy: 597.2134pt, rp0_item_p001_b018_11_body)
}
#let rp0_item_p001_b019_12_md = "2. 卸料区"
#let rp0_item_p001_b019_12_body = block(width: 92.47200000000001pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp0_item_p001_b019_12_md, max_size: 12.25pt, min_size: 10.05pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 100.47pt, dy: 610.2113999999998pt, rp0_item_p001_b019_12_body)
}
#let rp0_item_p001_b020_13_md = "3. 急救设施"
#let rp0_item_p001_b020_13_body = block(width: 108.46700000000001pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp0_item_p001_b020_13_md, max_size: 11.27pt, min_size: 9.07pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 100.47pt, dy: 638.3903999999998pt, rp0_item_p001_b020_13_body)
}
#let rp0_item_p001_b021_14_md = "4. 维护与办公空间"
#let rp0_item_p001_b021_14_body = block(width: 173.94699999999997pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp0_item_p001_b021_14_md, max_size: 12.74pt, min_size: 10.54pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 99.47pt, dy: 664.4276999999998pt, rp0_item_p001_b021_14_body)
}
#let rp0_item_p001_b022_15_md = "5. 预制构件与存储区域"
#let rp0_item_p001_b022_15_body = block(width: 214.93499999999997pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp0_item_p001_b022_15_md, max_size: 12.74pt, min_size: 10.54pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 99.97pt, dy: 693.7338999999998pt, rp0_item_p001_b022_15_body)
}
#let rp0_item_p001_b023_16_md = "6. 集装箱堆场照明"
#let rp0_item_p001_b023_16_body = block(width: 217.434pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp0_item_p001_b023_16_md, max_size: 12.25pt, min_size: 10.05pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 99.97pt, dy: 723.0400999999998pt, rp0_item_p001_b023_16_body)
}
#let rp0_item_p001_b024_17_md = "7. 承包商开票"
#let rp0_item_p001_b024_17_body = block(width: 127.96100000000001pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp0_item_p001_b024_17_md, max_size: 11.27pt, min_size: 9.07pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 100.47pt, dy: 751.2180999999998pt, rp0_item_p001_b024_17_body)
}
#let rp0_item_p001_b025_18_md = "5. 会议闭幕"
#let rp0_item_p001_b025_18_body = block(width: 133.459pt, height: 13.999000000000024pt)[#{ pdftr_fit_markdown(rp0_item_p001_b025_18_md, max_size: 13.72pt, min_size: 11.52pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 13.999000000000024pt) }]
#context {
  place(top + left, dx: 76.977pt, dy: 777.2553999999999pt, rp0_item_p001_b025_18_body)
}
#let rp0_item_p001_b027_19_md = "驻地工程师 - RE（IL - Eng. José Rodrigues）宣布会议开始，并对与会成员表示欢迎。本次会议由驻地工程师代表工程师主持。"
#let rp0_item_p001_b027_19_body = block(width: 458.86199999999997pt, height: 25.918000000000006pt)[#{ pdftr_fit_markdown(rp0_item_p001_b027_19_md, max_size: 11.34pt, min_size: 10.54pt, max_leading: 0.6em, min_leading: 0.52em, fit_height: 25.918000000000006pt) }]
#context {
  place(top + left, dx: 81.475pt, dy: 832.7503999999998pt, rp0_item_p001_b027_19_body)
}
#pagebreak()
#set page(width: 595.3200073242188pt, height: 841.9200439453125pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 2, width: 595.3200073242188pt))
#let rp1_item_p002_b004_0_md = "<table><tr><td>项次</td><td>说明</td><td>行动</td></tr><tr><td>2.0</td><td>承包商开工准备情况</td><td></td></tr><tr><td></td><td>关于现场可达性，驻地工程师向会议通报，正如2026年5月12日三方会议所报告的，目前在港区内获取工作空间仍然困难。尽管如此，业主承诺将继续与迪拜环球港务集团跟进，一旦时机合适，即为承包商分配空间。随后，会议同意坦桑尼亚港务局将与迪拜环球港务集团协调，提前为承包商工人办理港区通行证，以便在条件允许开工时顺利进入。关于铺路砌块，承包商被要求提供代表性样品以及源自拟用于现场施工的实际生产的验证试验结果。承包商向会议通报，其在国内无法找到能够进行抗滑试验的合格实验室，因此请求驻地工程师协助在坦桑尼亚境内寻找可进行该试验的实验室。驻地工程师已承诺调查此事并将相应给出建议。同时，工程师正在分析承包商提交的劈裂抗拉试验结果，并将尽快给出答复。</td><td>INFO</td></tr><tr><td>3.0</td><td>合同事宜</td><td></td></tr><tr><td>3.1</td><td>劳工、材料和设备</td><td></td></tr><tr><td></td><td>驻地工程师再次提醒承包商，应根据合同中批准的人员名单提交所有员工（包括本地和外国员工）的名单。关于外国员工，驻地工程师提醒承包商提交护照入境许可复印件，以证明其获准进入并在该国工作。承包商承诺在2026年5月21日下次会议前提交。关于已调遣的设备，驻地工程师询问有缺陷的空压机是否已修复。承包商向会议通报，其仍在等待从中国订购的备件，预计于2026年5月底前到货。关于混凝土配合比设计，承包商已提交28天试验结果，工程师正在核查并将相应回复。</td><td>CHEC</td></tr><tr><td>3.3</td><td>项目管理设施</td><td></td></tr><tr><td></td><td>驻地工程师向会议通报，坦桑尼亚港务局方面无最新进展。</td><td>TPA</td></tr><tr><td>3.4</td><td>日报、周报和月报</td><td></td></tr><tr><td></td><td>驻地工程师向会议通报，已按合同要求收到承包商提交的相应报告。周报应按周提交，周期为周一至周日。</td><td>CHEC</td></tr></table>"
#let rp1_item_p002_b004_0_body = block(width: 498.849pt)[#{ set text(size: 11.4pt); set par(leading: 0.72em); cmarker.render(rp1_item_p002_b004_0_md, math: mitex) }]
#context {
  place(top + left, dx: 54.484pt, dy: 145.486pt, rp1_item_p002_b004_0_body)
}
#pagebreak()
#set page(width: 595.3200073242188pt, height: 841.9200439453125pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 3, width: 595.3200073242188pt))
#let rp2_item_p003_b004_0_md = "<table><tr><td colspan=\"2\">4.0 其他事项</td></tr><tr><td colspan=\"2\">4.1 新缺陷</td></tr><tr><td colspan=\"2\">关于新缺陷，驻地工程师向会议通报，业主尚未就拟与各方联合检查以确定合同已识别裂缝之外的新裂缝一事提供最新进展。</td></tr><tr><td colspan=\"2\">4.2 弃土区</td></tr><tr><td>关于弃土区，承包商仍在等待坦桑尼亚港务局的正式函件。</td><td>TPA</td></tr><tr><td colspan=\"2\">4.3 急救设施</td></tr><tr><td>第三个急救室集装箱已于4月10日在供应商处由承包商和工程师联合检查，确认其满足需求。承包商向会议通报，一旦收到来自中国的资金用于支付制造费用，该集装箱将运至现场，并于2026年5月底前完成交付。</td><td>CHEC</td></tr><tr><td colspan=\"2\">4.4 维护与办公空间</td></tr><tr><td>驻地工程师向会议通报，观察到周边环境有显著改善，即使在近期降雨期间也未闻到异味。</td><td>CHEC</td></tr><tr><td colspan=\"2\">4.5 预制构件及存储区域</td></tr><tr><td>关于港区内预制构件所需空间，承包商向会议通报，其已决定从港区外采购预制构件，因此不再像先前讨论那样迫切需要港区内空间。驻地工程师再次指示承包商以书面形式确认不再需要该设施。承包商承诺在2026年5月21日下次会议前提交书面确认。</td><td>INFO</td></tr><tr><td colspan=\"2\">4.6 集装箱堆场照明</td></tr><tr><td>承包商提交了建议采用410瓦照明的方案，但驻地工程师告知设计要求为1000瓦。驻地工程师表示已收到承包商关于港区照明建议的支持文件，将予以审查并相应回复承包商。</td><td>CHEC</td></tr><tr><td colspan=\"2\">4.7 承包商发票开具</td></tr><tr><td>驻地工程师建议承包商核实当前已支出金额是否低于或高于合同规定的开具发票所需最低金额（2%）。</td><td>CHEC</td></tr></table>"
#let rp2_item_p003_b004_0_body = block(width: 498.849pt)[#{ set text(size: 11.4pt); set par(leading: 0.72em); cmarker.render(rp2_item_p003_b004_0_md, math: mitex) }]
#context {
  place(top + left, dx: 54.484pt, dy: 147.986pt, rp2_item_p003_b004_0_body)
}
#pagebreak()
#set page(width: 595.3200073242188pt, height: 841.9200439453125pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 4, width: 595.3200073242188pt))
#let rp3_item_p004_b004_0_md = "<table><tr><td>5.0</td><td>会议闭幕</td><td></td></tr><tr><td></td><td>鉴于无其他事项，会议于14:56宣布结束</td><td>全体</td></tr></table>"
#let rp3_item_p004_b004_0_body = block(width: 496.84999999999997pt)[#{ set text(size: 11.4pt); set par(leading: 0.72em); cmarker.render(rp3_item_p004_b004_0_md, math: mitex) }]
#context {
  place(top + left, dx: 56.483pt, dy: 146.986pt, rp3_item_p004_b004_0_body)
}
#let rp3_item_p004_b006_1_md = "签署人："
#let rp3_item_p004_b006_1_body = block(width: 56.98199999999999pt, height: 14.99799999999999pt)[#{ pdftr_fit_markdown(rp3_item_p004_b006_1_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 14.99799999999999pt) }]
#context {
  place(top + left, dx: 54.484pt, dy: 236.478pt, rp3_item_p004_b006_1_body)
}
#let rp3_item_p004_b007_2_md = "<table><tr><td>承包商代表副代表 程永建 工程师<br>代表承包商——CHEC</td><td>☑</td></tr></table>"
#let rp3_item_p004_b007_2_body = block(width: 495.84999999999997pt)[#{ set text(size: 11.4pt); set par(leading: 0.72em); cmarker.render(rp3_item_p004_b007_2_md, math: mitex) }]
#context {
  place(top + left, dx: 56.483pt, dy: 261.975pt, rp3_item_p004_b007_2_body)
}
#let rp3_item_p004_b008_3_md = "<table><tr><td>Eng. José Rodrigues</td><td></td></tr><tr><td>驻地工程师</td><td></td></tr><tr><td>代表工程师 - IL</td><td></td></tr></table>"
#let rp3_item_p004_b008_3_body = block(width: 495.84999999999997pt)[#{ set text(size: 11.4pt); set par(leading: 0.72em); cmarker.render(rp3_item_p004_b008_3_md, math: mitex) }]
#context {
  place(top + left, dx: 56.983pt, dy: 334.968pt, rp3_item_p004_b008_3_body)
}
#pagebreak()
#set page(width: 595.3200073242188pt, height: 841.9200439453125pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 5, width: 595.3200073242188pt))
#let rp4_item_p005_b005_0_md = "**图/表标题：** 达累斯萨拉姆港滚装码头设计与施工、1-7号泊位加深与加固及码头修复工程，合同号：TZ-TPA-424013-CW-DIR，主题：第15次周例会"
#let rp4_item_p005_b005_0_body = block(width: 26.99199999999999pt)[#{ set text(size: 10.6pt); set par(leading: 0.72em); cmarker.render(rp4_item_p005_b005_0_md, math: mitex) }]
#context {
  place(top + left, dx: 131.46pt, dy: 382.464pt, rp4_item_p005_b005_0_body)
}
#let rp4_item_p005_b009_1_md = "| 序号 | 姓名 | 公司 | 手机 | 邮箱 | 职务 | 签名 |\n|------|------|------|------|------|------|------|\n| 1 | Josh Rode-Riggs | IL | 0787-608922 | josh.roeson@example.com | 驻地工程师 | F. |\n| 2 | Johnstone Muttlemore | IL | 0713250187 | johnsyberg@example.com | 助理驻地工程师 | J. |\n| 3 | Geraldine J. Khatseri | IL | 075426325 | gledan@example.com | 现场主管 | D. |\n| 4 | Alexis B. Ruiz | IL | 0754388423 | nita2923@example.com | 焊接检验员 | W. |\n| 5 | Gidish Curney | IL | 076220098 | g.92.com_g@example.com | 材料检验员 | M. |\n| 6 | Bahda Gurney | IL | 0787110604 | mattygianey@yahoo.com | 项目秘书 | P. |\n| 7 | 程阳健 | CHEC | 0777024687 | yicheng@example.com | 副首席代表 | 文和健 |\n| 8 | 金世文 | CHEC | 0656359636 | swijin@example.com | 土木工程师 | 新政 |\n| 9 | 陈一东·艾娜 | CHEC | 0741183600 | yotchen@example.com | 土木工程师 | 陈江东 |\n| 10 | Khadija EL KHEBIR | CHEC | 0790931306 | kheki.thec@example.com | 合同专员 | G. |\n| 11 | 王晨 | CHEC | 062318998 | 12925344999.com | 现场工程师 | A. |\n| 12 | | | | | | |\n| 13 | | | | | | |\n| 14 | | | | | | |\n| 15 | | | | | | |\n| 16 | | | | | | |\n| 17 | | | | | | |\n| 18 | | | | | | |\n| 19 | | | | | | |\n| 20 | | | | | | |"
#let rp4_item_p005_b009_1_body = block(width: 304.908pt)[#{ set text(size: 11.4pt); set par(leading: 0.72em); cmarker.render(rp4_item_p005_b009_1_md, math: mitex) }]
#context {
  place(top + left, dx: 178.946pt, dy: 156.485pt, rp4_item_p005_b009_1_body)
}

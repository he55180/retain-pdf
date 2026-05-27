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
#set page(width: 595.3200073242188pt, height: 841.9199829101562pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 1, width: 595.3200073242188pt))
#let rp0_item_p001_b000_0_md = "关于在达累斯萨拉姆港马林迪码头区现代化设计与建造项目中开展艾滋病与新冠肺炎意识提升计划的提案"
#let rp0_item_p001_b000_0_body = block(width: 428.1156000000002pt, height: 37.97894983425414pt)[#{ pdftr_fit_markdown(rp0_item_p001_b000_0_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 37.97894983425414pt) }]
#context {
  place(top + left, dx: 85.21020000000001pt, dy: 372.92609414364637pt, rp0_item_p001_b000_0_body)
}
#pagebreak()
#set page(width: 595.3200073242188pt, height: 841.9199829101562pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 2, width: 595.3200073242188pt))
#let rp1_item_p002_b001_0_md = "目录"
#let rp1_item_p002_b001_0_body = block(width: 142.62pt, height: 14.04pt)[#{ pdftr_fit_single_line_markdown(rp1_item_p002_b001_0_md, max_size: 12.85pt, min_size: 10.65pt, fit_width: 142.62pt, fit_height: 14.04pt, weight: "bold") }]
#context {
  place(top + left, dx: 231.624472pt, dy: 159.0378904pt, rp1_item_p002_b001_0_body)
}
#let rp1_item_p002_b003_1_md = "0.0 执行摘要 ................................................................................................................... 2"
#let rp1_item_p002_b003_1_body = block(width: 428.34360000000004pt, height: 10.05424000000005pt)[#{ pdftr_fit_markdown(rp1_item_p002_b003_1_md, max_size: 9.66pt, min_size: 7.46pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 10.05424000000005pt) }]
#context {
  place(top + left, dx: 83.2962pt, dy: 178.5648799999999pt, rp1_item_p002_b003_1_body)
}
#let rp1_item_p002_b004_2_md = "1.0 引言 ............................................................................................................................... 3"
#let rp1_item_p002_b004_2_body = block(width: 428.34360000000004pt, height: 10.05424000000005pt)[#{ pdftr_fit_markdown(rp1_item_p002_b004_2_md, max_size: 9.66pt, min_size: 7.46pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 10.05424000000005pt) }]
#context {
  place(top + left, dx: 83.2962pt, dy: 204.12487999999996pt, rp1_item_p002_b004_2_body)
}
#let rp1_item_p002_b005_3_md = "1.1 培训目标 .............................................................................................................. 3"
#let rp1_item_p002_b005_3_body = block(width: 417.85560000000004pt, height: 10.05424000000005pt)[#{ pdftr_fit_markdown(rp1_item_p002_b005_3_md, max_size: 9.66pt, min_size: 7.46pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 10.05424000000005pt) }]
#context {
  place(top + left, dx: 94.0602pt, dy: 229.8048799999999pt, rp1_item_p002_b005_3_body)
}
#let rp1_item_p002_b006_4_md = "1.2 目标参与者 ............................................................................................................. 4"
#let rp1_item_p002_b006_4_body = block(width: 417.85560000000004pt, height: 10.05424000000005pt)[#{ pdftr_fit_markdown(rp1_item_p002_b006_4_md, max_size: 9.66pt, min_size: 7.46pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 10.05424000000005pt) }]
#context {
  place(top + left, dx: 94.0602pt, dy: 255.48487999999998pt, rp1_item_p002_b006_4_body)
}
#let rp1_item_p002_b007_5_md = "2.0 培训方法 ............................................................................................................ 4"
#let rp1_item_p002_b007_5_body = block(width: 428.34360000000004pt, height: 10.05424000000005pt)[#{ pdftr_fit_markdown(rp1_item_p002_b007_5_md, max_size: 9.66pt, min_size: 7.46pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 10.05424000000005pt) }]
#context {
  place(top + left, dx: 83.2962pt, dy: 281.19488pt, rp1_item_p002_b007_5_body)
}
#let rp1_item_p002_b008_6_md = "3.0 六个月培训计划 .......................................................................................................... 4"
#let rp1_item_p002_b008_6_body = block(width: 428.34360000000004pt, height: 10.05424000000005pt)[#{ pdftr_fit_markdown(rp1_item_p002_b008_6_md, max_size: 9.66pt, min_size: 7.46pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 10.05424000000005pt) }]
#context {
  place(top + left, dx: 83.2962pt, dy: 306.87487999999996pt, rp1_item_p002_b008_6_body)
}
#let rp1_item_p002_b009_7_md = "4.0 项目预期规定 ............................................................................ 5"
#let rp1_item_p002_b009_7_body = block(width: 428.34360000000004pt, height: 10.054239999999993pt)[#{ pdftr_fit_markdown(rp1_item_p002_b009_7_md, max_size: 9.66pt, min_size: 7.46pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 10.054239999999993pt) }]
#context {
  place(top + left, dx: 83.2962pt, dy: 332.43487999999996pt, rp1_item_p002_b009_7_body)
}
#let rp1_item_p002_b010_8_md = "5.0 预期成果 ............................................................................................................. 5"
#let rp1_item_p002_b010_8_body = block(width: 428.34360000000004pt, height: 10.054239999999993pt)[#{ pdftr_fit_markdown(rp1_item_p002_b010_8_md, max_size: 9.66pt, min_size: 7.46pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 10.054239999999993pt) }]
#context {
  place(top + left, dx: 83.2962pt, dy: 358.11487999999997pt, rp1_item_p002_b010_8_body)
}
#let rp1_item_p002_b011_9_md = "6.0 培训成本 ............................................................................................................................... 6"
#let rp1_item_p002_b011_9_body = block(width: 428.34360000000004pt, height: 10.054239999999993pt)[#{ pdftr_fit_markdown(rp1_item_p002_b011_9_md, max_size: 9.66pt, min_size: 7.46pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 10.054239999999993pt) }]
#context {
  place(top + left, dx: 83.2962pt, dy: 383.79488pt, rp1_item_p002_b011_9_body)
}
#let rp1_item_p002_b012_10_md = "7.0 结论 ................................................................................................................................... 6"
#let rp1_item_p002_b012_10_body = block(width: 428.34360000000004pt, height: 10.054239999999993pt)[#{ pdftr_fit_markdown(rp1_item_p002_b012_10_md, max_size: 9.66pt, min_size: 7.46pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 10.054239999999993pt) }]
#context {
  place(top + left, dx: 83.2962pt, dy: 409.47488pt, rp1_item_p002_b012_10_body)
}
#let rp1_item_p002_b013_11_md = "8.0 附录 .................................................................................................................................... 6"
#let rp1_item_p002_b013_11_body = block(width: 428.34360000000004pt, height: 10.054239999999993pt)[#{ pdftr_fit_markdown(rp1_item_p002_b013_11_md, max_size: 9.66pt, min_size: 7.46pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 10.054239999999993pt) }]
#context {
  place(top + left, dx: 83.2962pt, dy: 435.03487999999993pt, rp1_item_p002_b013_11_body)
}
#let rp1_item_p002_b014_12_md = "附录I：联系信息 ......................................................................................... 6"
#let rp1_item_p002_b014_12_body = block(width: 417.85560000000004pt, height: 10.054239999999993pt)[#{ pdftr_fit_markdown(rp1_item_p002_b014_12_md, max_size: 9.66pt, min_size: 7.46pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 10.054239999999993pt) }]
#context {
  place(top + left, dx: 94.0602pt, dy: 460.71487999999994pt, rp1_item_p002_b014_12_body)
}
#pagebreak()
#set page(width: 595.3200073242188pt, height: 841.9199829101562pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 3, width: 595.3200073242188pt))
#let rp2_item_p003_b001_0_md = "0.0 执行摘要"
#let rp2_item_p003_b001_0_body = block(width: 174.47pt, height: 14.04pt)[#{ pdftr_fit_single_line_markdown(rp2_item_p003_b001_0_md, max_size: 12.85pt, min_size: 10.65pt, fit_width: 174.47pt, fit_height: 14.04pt, weight: "bold") }]
#context {
  place(top + left, dx: 76.39662200000001pt, dy: 109.23789039999991pt, rp2_item_p003_b001_0_body)
}
#let rp2_item_p003_b002_1_md = "坦桑尼亚政府通过坦桑尼亚港务局（TPA），正在升级达累斯萨拉姆港的马林迪码头（Malindi Wharf），以提升货物装卸能力和运营效率。作为该国主要海港以及多个内陆国家的关键区域贸易门户，该港在东非经济中发挥着重要作用。项目包括建设一个多用途泊位及相关支持性基础设施，如进场道路、作业场地、公用设施及改进的港口系统，采用设计施工总承包合同模式，由中国港湾工程有限责任公司承建。"
#let rp2_item_p003_b002_1_body = block(width: 431.2771999999998pt, height: 74.68864000000002pt)[#{ pdftr_fit_markdown(rp2_item_p003_b002_1_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 74.68864000000002pt) }]
#context {
  place(top + left, dx: 83.3734pt, dy: 144.86767999999992pt, rp2_item_p003_b002_1_body)
}
#let rp2_item_p003_b003_2_md = "大型建设项目会带来公共卫生风险，尤其是由于劳动力流动和卫生服务可及性有限，导致艾滋病和新冠肺炎的传播。鉴于坦桑尼亚的艾滋病负担，有针对性的工作场所干预措施对于保护工人、周边社区以及整体生产力至关重要。"
#let rp2_item_p003_b003_2_body = block(width: 431.4329999999998pt, height: 48.88564000000008pt)[#{ pdftr_fit_markdown(rp2_item_p003_b003_2_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 48.88564000000008pt) }]
#context {
  place(top + left, dx: 83.3775pt, dy: 240.64417999999995pt, rp2_item_p003_b003_2_body)
}
#let rp2_item_p003_b004_3_md = "针对这些挑战，Vision Care Clinic 计划为参与 Malindi Wharf 现代化项目的员工实施一项全面的艾滋病与新冠肺炎认知及预防计划。该计划将着重提升认知、推广安全行为、促进检测与咨询服务获取，并加强与治疗和关怀服务的衔接。"
#let rp2_item_p003_b004_3_body = block(width: 430.90479999999957pt, height: 69.61264000000006pt)[#{ pdftr_fit_markdown(rp2_item_p003_b004_3_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 69.61264000000006pt) }]
#context {
  place(top + left, dx: 83.36359999999999pt, dy: 310.3356799999999pt, rp2_item_p003_b004_3_body)
}
#let rp2_item_p003_b005_4_md = "该计划还满足国家法律和国际标准下的法律与合同要求，同时按照《艾滋病（预防与控制）法案》确保健康信息的严格保密。"
#let rp2_item_p003_b005_4_body = block(width: 430.8401999999995pt, height: 35.8854399999999pt)[#{ pdftr_fit_markdown(rp2_item_p003_b005_4_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 35.8854399999999pt) }]
#context {
  place(top + left, dx: 83.36189999999999pt, dy: 402.49928pt, rp2_item_p003_b005_4_body)
}

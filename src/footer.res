type footer = {
  image: string,
  name: string,
  description: string,
  phone: string,
  logo: string,
  highlightText: string,
  extraText: string,
}

let make_footer = footer =>
  `
  <table style="font-family: arial; margin-left: 20px;">
    <tbody>
      <tr>
        <td style="padding-right: 20px;">
          <img
            style="width: 110px; height: 110px;"
            src="${footer.image}"
          />
        </td>
        <td>
          <h2
            style="
              margin: 0px;
              font-size: 18px;
              margin-top: 1px;
            "
          >
            ${footer.name}
          </h2>
          <p style="
            margin: 0px;
            line-height: 30px;
            font-size: 14px;
            font-weight: lighter;
          ">
            ${footer.description}
          </p>
          <p style="
            color: #4565AF;
            margin: 0px;
            font-size: 14px;
            font-weight: lighter;
          ">
            ${footer.phone}
          </p>
        </td>
      </tr>
      <tr/>
        <td style="
            height: 40px;
            display: flex;
            align-items: center;
        ">
          <img
            style="
              position: relative;
              left: 4px;
              width: 90px;
              margin: auto;
              display: block;
            "
            src="${footer.logo}"
          />
        </td>

        <td style="text-align: center;">
          <p
            style="
              margin: 0px;
              line-height: 40px;
              font-size: 14px;
              font-weight: lighter;
            "
          >
            <span style="color: #4cbf94;">${footer.highlightText}</span>
            ${footer.extraText}
          </p>
        </td>

      </tr>
    </tbody>
  </table>
`

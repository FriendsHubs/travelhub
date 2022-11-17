import { Fragment } from "react";

export function Content({ children }: any) {
  return (
    <Fragment>
      <div className="h-[6px] bg-gradient-to-r from-[#665AEF] to-[#FC364C]" />
      <div className="content-gradient px-[21px]  pt-[42px] min-h-[1307px] mb:pb-0 pb-5">
        {children}
      </div>
    </Fragment>
  );
}

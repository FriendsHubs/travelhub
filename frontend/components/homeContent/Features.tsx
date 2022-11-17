
export function Features({ children }: any) {
  return (
    <div className="xl:px-[99px] lg:px[80px] md:px-[16px] px-1  text-white">
      <div className="grid md:grid-cols-2   md:gap-x-[19px]  gap-y-[24px]">
      {children}
      </div>
    </div>
  );
}

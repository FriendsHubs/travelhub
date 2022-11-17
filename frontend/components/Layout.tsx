interface ILayout {
  children: {
    header?: React.ReactChild;
    body?: React.ReactChild;
    footer?: React.ReactChild;
  };
}

function Layout({ children }: ILayout) {
  return (
    <div className="max-w-[90rem] mx-auto">
      <div className="flex justify-center">
        <div className="w-full">
          {children.header}
          {children.body}
          {children.footer}
        </div>
      </div>
    </div>
  );
}

export default Layout;
